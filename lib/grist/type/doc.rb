# frozen_string_literal: true

module Grist
  module Type
    # Defines a Grist Workspace
    class Doc < Grist::Type::Base
      PATH = "/docs"
      KEYS = %w[
        name
        createdAt
        updatedAt
        id
        isPinned
        urlId
        trunkId
        type
        forks
        access
      ].freeze

      attr_accessor(*KEYS)

      def initialize(params = {})
        super params
        @ws_id = params[:ws_id]
      end

      def tables
        @tables ||= TablesCollection.new(id: @id, ws_id: @ws_id)
      end

      # def base_api_url
      #   "#{ENV["GRIST_API_URL"]}/api/orgs/#{@org_id}"
      # end

      # Updates the Document
      # # @param id [Integer] The ID of the workspace to delete
      # # # @param data [Hash] The data to update the workspace with
      # # @return [self | nil] The updated workspace or nil if not found
      def self.create(ws_id, data)
        obj = new(ws_id:)
        obj.create(data)
      end

      # List all workspaces
      # # # @return [Array] Array of workspaces
      def self.all(org_id)
        grist_res = new(org_id:).list
        return [] unless grist_res&.data.is_a?(Array)

        grist_res.data&.map { |org| Workspace.new(org) }
      end

      # Finds an workspace by ID
      # # @param id [Integer] The ID of the workspace to find
      # # # return [self | nil] The workspace or nil if not found
      def self.find(id)
        grist_res = new.get(id)
        return unless grist_res.success? && grist_res.data

        new(grist_res.data)
      end

      def self.tables(doc_id)
        doc = find(doc_id)
        return unless org

        doc.tables
      end
    end
  end
end
