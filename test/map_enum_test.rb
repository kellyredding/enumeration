require "test/helper"

class MapEnumTest < Test::Unit::TestCase
  context "instance" do

    subject { Thing.new }
    before do
      Thing.send :include, Enumeration
      Thing.send(:enum, :stuff, {
        :a => "aye",
        :b => "bee",
        :c => "see"
      })
    end

    should_have_class_method :stuff, :stuff_set

    should "provide class level access to the enum" do
      stuffs = Thing.send(:class_variable_get, "@@stuff")
      assert stuffs
      assert_kind_of ::Hash, stuffs
      assert !stuffs.empty?
      assert_equal 3, stuffs.size
      assert_equal stuffs.keys, Thing.stuff_set
      assert_equal "aye", Thing.stuff(:a)
    end

    should_have_accessor :stuff

    should "write by key and read by value" do
      subject.stuff = :b
      assert_equal "bee", subject.stuff
    end

    should "write by value and read by value" do
      subject.stuff = "see"
      assert_equal "see", subject.stuff
    end

    should "not read by key" do
      subject.stuff = :c
      assert_not_equal :c, subject.stuff
    end

    should "write nil for keys that aren't in the enum" do
      subject.stuff = :bad
      assert_equal nil, subject.stuff
    end

    should "write nil for values that aren't in the enum" do
      subject.stuff = "bady-bad"
      assert_equal nil, subject.stuff
    end

  end
end
