require 'rails_helper'

RSpec.describe "WeightHistories", type: :system do

  describe "weight histories index" do
    let!(:weight_histroy) { create(:weight_histroy) }

    it "shows all weight histories and navigates to new weight history page" do
      visit weight_histroys_path
      
      expect(page).to have_content(weight_histroy.memo) 
    end
  end
end