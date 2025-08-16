# frozen_string_literal: true

module Grist
  module Type
    class TablesCollection < Grist::Type::Base
      def initialize(params = {})
        super params
        @id = params[:id]
        @ws_id = params[:ws_id]
      end

      def all
        return @all if defined?(@tables)

        grist_res = request(:get, tables_path)
        return [] if grist_res&.error?

        @all = grist_res.data['tables']&.map do |t|
          Table.new(t.merge(doc_id: @id, ws_id: @ws_id))
        end
      end

      def create(data)
        grist_res = request(:post, tables_path, data)

        return nil unless grist_res&.data.is_a?(Array)
      end

      def find(id)
        Table.new(doc_id: @id, ws_id: @ws_id, id:)
      end

      private

      def tables_path
        "/docs/#{@id}/tables"
      end
    end
  end
end
