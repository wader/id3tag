# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::TextFrame do
  let(:id) { "artist" }
  let(:raw_content) { text.encode(target_encoding).prepend(encoding_byte.force_encoding(target_encoding)) }
  let(:flags) { nil }
  let(:major_version_number) { 4 }

  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }
  let(:target_encoding) { Encoding::UTF_8 }
  let(:encoding_byte) { "\x03" }
  let(:text) { "Glāzšķūņrūķīši" }

  describe '#id' do
    subject { frame.id }
    it { should == :artist }
  end

  describe '#content' do
    subject { frame.content }

    context "when encoding byte is not present" do
      let(:encoding_byte) { "" }
      it { expect { subject }.to raise_error(ID3Tag::Frames::V2::TextFrame::UnsupportedTextEncoding) }
    end

    context "when encoding is ISO08859_1" do
      let(:target_encoding) { Encoding::ISO8859_1 }
      let(:encoding_byte) { "\x00" }
      let(:text) { "some fancy artist" }
      it { should == 'some fancy artist' }
    end

    context "when encoding is UTF_16" do
      let(:target_encoding) { Encoding::UTF_16 }
      let(:encoding_byte) { "\x01" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when encoding is UTF_16BE" do
      let(:target_encoding) { Encoding::UTF_16BE }
      let(:encoding_byte) { "\x02" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when encoding is UTF_8" do
      let(:target_encoding) { Encoding::UTF_8 }
      let(:encoding_byte) { "\x03" }
      it { should == 'Glāzšķūņrūķīši' }
    end
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::TextFrame artist: Glāzšķūņrūķīši>')
    end
  end
end
