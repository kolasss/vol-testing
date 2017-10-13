shared_examples "json content type" do
  it 'have json content type' do
    expect(response.content_type).to eq("application/json")
  end
end
