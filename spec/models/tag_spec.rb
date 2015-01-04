require 'spec_helper'

describe Tag do
  describe 'associations' do
    it { should belong_to :tag_category }
  end
end