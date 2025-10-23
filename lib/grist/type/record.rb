# frozen_string_literal: true

module Grist
  module Type
    # Defines a Grist Workspace
    class Record < Grist::Type::Base
      PATH = "/records"
      KEYS = %w[
        id
        fields
      ].freeze

      attr_accessor(*KEYS)

      def initialize(params = {})
        super params
        @table_id = params[:table_id]
        @doc_id = params[:doc_id]
      end

      def add(required = [])
        # https://support.getgrist.com/api/#tag/records/operation/replaceRecords
        #
        # put https://{gristhost}/api/docs/{docId}/tables/{tableId}/records
        # { require: { a: 1, b: 2}, fields: { }}
        #
        real_required = {}
        required.each do |name|
          raise "field #{name} is not in data" unless fields.key?(name)

          real_required[name] = fields[name]
        end

        grist_res = request(:put, path, { records: [{ require: real_required, fields: }] })

        return unless grist_res.success?

        self
      end

      private

      def path
        "/docs/#{@doc_id}/tables/#{@table_id}/records"
      end
    end
  end
end
