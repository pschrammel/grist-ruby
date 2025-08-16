# frozen_string_literal: true

module Grist
  module Type
    class RecordsCollection < Grist::Type::Base
      def initialize(params = {})
        super params
        @table_id = params[:table_id]
        @doc_id = params[:doc_id]
      end

      def all(params = {})
        grist_res = request(:get, records_path, params)

        return [] unless grist_res.success? && grist_res.data

        grist_res.data["records"].map do |record|
          Record.new(record.merge(doc_id: @doc_id, table_id: @table_id))
        end
      end

      def add(data, required = [])
        data = { fields: data }
        rec = Record.new(data.merge(doc_id: @doc_id, table_id: @table_id))
        rec.add(required)
        rec
      end

      private

      def records_path
        "/docs/#{@doc_id}/tables/#{@table_id}/records"
      end
    end
  end
end
