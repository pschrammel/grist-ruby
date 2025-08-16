# frozen_string_literal: true

module Grist
  class Cli < Thor
    desc "columns <TABLE>", "show the table's columns"
    def columns(docid, table_name)
      doc = Grist::Type::Doc.find(docid)
      table = doc.tables.find(table_name)
      columns = table.columns

      col_names = columns.values.map { |col| { id: col.id, type: col.fields["type"], label: col.fields["label"] } }
      # p columns.values
      tp col_names
    end

    desc "dump <TABLE>", "dump"
    def dump(docid, table_name)
      doc = Grist::Type::Doc.find(docid)
      table = doc.tables.find(table_name)

      records = table.records.all.map do |record|
        record.fields.merge(id: record.id)
      end

      tp records
    end

    desc "upsert <TABLE> <CSV> key1,key2", "upsert"
    def upsert(docid, table_name, csv_filename, required)
      doc = Grist::Type::Doc.find(docid)
      table = doc.tables.find(table_name)
      columns = table.columns
      csv = CSV.read(csv_filename, headers: true)
      diff = csv.headers - columns.keys
      exit_error("some unknown fields in the csv: #{diff.join(",")}") unless diff.empty?

      required = required.split(",")
      diff = required - columns.keys
      exit_error("some unknown names for keys: #{diff.join(",")}") unless diff.empty?

      real_required = required.map { |req| columns[req].id }

      send_data = csv.map do |csv_row|
        data = {}
        csv_row.to_h.each_pair do |key, value|
          data[columns[key].id] = value
        end
        data
      end
      send_data.each do |data|
        table.records.add(data, real_required)
      end
    end

    desc "tables", "tables"
    def tables(docid)
      doc = Grist::Type::Doc.find(docid)
      tables = doc.tables

      tables.all.each do |table|
        p table.id
      end
    end
  end
end
