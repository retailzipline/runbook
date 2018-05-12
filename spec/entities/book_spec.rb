require "spec_helper"

RSpec.describe Runbook::Entities::Book do
  let(:title) { "Some Title" }
  let(:book) { Runbook::Entities::Book.new(title) }

  it "has a title" do
    expect(book.title).to eq(title)
  end

  describe "#section" do
    it "adds a section to the book's items" do
      section = book.section("My Section") {}
      expect(book.items).to include(section)
    end

    it "adds itself as the new section's parent" do
      section = book.section("My Section") {}
      expect(section.parent).to eq(book)
    end

    it "adds to the book's existing items" do
      section1 = book.section("My Section") {}
      section2 = book.section("My Other Section") {}
      expect(book.items).to eq([section1, section2])
    end

    it "evaluates the block in the context of the section's dsl" do
      in_section = nil
      section = book.section("My Section") { in_section = self }
      expect(in_section).to eq(section.dsl)
    end
  end

  describe "#description" do
    it "adds a description to the book's items" do
      desc = book.description("My Description") {}
      expect(book.items).to include(desc)
    end

    it "adds itself as the new description's parent" do
      desc = book.description("My Description") {}
      expect(desc.parent).to eq(book)
    end

    it "adds to the book's existing items" do
      desc1 = book.description("My description") {}
      desc2 = book.description("My other description") {}
      expect(book.items).to eq([desc1, desc2])
    end
  end

  describe "#add" do
    let(:section) { Runbook.section("My Section") {} }

    it "adds a section to the book" do
      book.dsl.add(section)
      expect(book.items).to include(section)
    end

    it "adds itself as the section's parent" do
      book.dsl.add(section)
      expect(section.parent).to eq(book)
    end
  end
end
