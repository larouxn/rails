# frozen_string_literal: true

require "active_record_unit"

class PartialRenderingQueryTest < ActiveRecordTestCase
  def setup
    @view = ActionView::Base
      .with_empty_template_cache
      .with_view_paths(ActionController::Base.view_paths, {})
  end

  def test_render_with_relation_collection
    filter = Proc.new { %w[ SCHEMA TRANSACTION ].exclude?(_1.payload[:name]) }
    notifications = capture_notifications("sql.active_record", filter) do
      @view.render partial: "topics/topic", collection: Topic.all
    end

    assert_equal 1, notifications.size
    assert_equal 'SELECT "topics".* FROM "topics"', notifications.first.payload[:sql]
  end
end
