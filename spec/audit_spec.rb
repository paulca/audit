require File.dirname(__FILE__) + '/spec_helper'

class TestModel < ActiveRecord::Base
  audit

  def self.table_name
    'boojas'
  end
end

describe Audit do
  before(:each) do
    Audit.destroy_all
    @test_model = TestModel.new
  end
  
  it "should create a create audit on create" do
    @test_model.save!
    @test_model.audits.count.should == 1
    @test_model.audits.first.action.should == 'create'
    @test_model.audits.first.auditable.should == @test_model
    @test_model.audits.created.size.should == 1
    TestModel.created.size.should == 1
  end
  
  it "should create an update audit on update" do
    @test_model.save!
    @test_model.shortcode_url = 'hey'
    @test_model.save!
    @test_model.audits.count.should == 2
    @test_model.audits.last.action.should == 'update'
    @test_model.audits.last.auditable.should == @test_model
    @test_model.audits.created.size.should == 1
    @test_model.audits.updated.size.should == 1
    TestModel.updated.size.should == 1
  end
  
  it "should create a delete audit on delete" do
    @test_model.save!
    @test_model.destroy
    @test_model.audits.count.should == 2
    @test_model.audits.last.action.should == 'destroy'
    @test_model.audits.last.auditable_id.should == @test_model.id
    @test_model.audits.created.size.should == 1
    TestModel.destroyed.size.should == 1
  end
end