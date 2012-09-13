require 'spec_helper'

describe "Nutrition" do
  let(:file) { File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'nutrition.xml'), 'r') }
  let(:xml) { Nokogiri::XML(file) }

  subject {
     xml.set_terminology do |t|
       t.daily_values :path => 'daily-values' do |dv|
         dv.total_fat :path => 'total-fat' do |tf|
           tf.value :path => '.', :accessor => lambda { |node| node.text.to_i }
           tf.units :path => '@units'
         end
       end

       t.food do |food|
         food._name :path => 'name'
         food.mfr

         food.total_fat :path => 'total-fat' do |tf|
           tf.value :path => '.', :accessor => lambda { |node| node.text.to_i }
         end
       end
     end

     xml.nom!

     xml
  }

  it "should have total fat information" do
    subject.daily_values.total_fat.text.should == "65"
    subject.daily_values.total_fat.value.should include(65)
    subject.daily_values.total_fat.units.text.should =='g'

    subject.food.total_fat.value.inject(:+).should == 117
  end

  it "should have food names" do
    subject.food._name.text.should include("Avocado Dip")
  end
end
