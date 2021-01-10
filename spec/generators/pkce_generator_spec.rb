# frozen_string_literal: true

require 'spec_helper'
require 'generators/doorkeeper/pkce_generator'

describe 'Doorkeeper::PkceGenerator' do
  include GeneratorSpec::TestCase

  tests Doorkeeper::PkceGenerator
  destination ::File.expand_path('../tmp/dummy', __FILE__)

  describe 'after running the generator' do
    before :each do
      prepare_destination
    end

    context 'pre Rails 5.0.0' do
      it 'creates a migration with no version specifier' do
        stub_const("ActiveRecord::VERSION::MAJOR", 4)
        stub_const("ActiveRecord::VERSION::MINOR", 2)

        run_generator

        assert_migration 'db/migrate/enable_pkce.rb' do |migration|
          assert migration.include?("ActiveRecord::Migration\n")
        end
      end
    end

    context 'post Rails 5.0.0' do
      it 'creates a migration with a version specifier' do
        stub_const("ActiveRecord::VERSION::MAJOR", 5)
        stub_const("ActiveRecord::VERSION::MINOR", 0)

        run_generator

        assert_migration 'db/migrate/enable_pkce.rb' do |migration|
          assert migration.include?("ActiveRecord::Migration[5.0]\n")
        end
      end
    end
  end
end
