describe UsersController, type: :controller do
  let(:params) { {} }
  let(:json_response) { JSON.parse(subject.body) }
  let(:response_ids) { json_response.map { |r| r['id'] } }

  subject do
    get :index, params: params

    response
  end

  describe 'limit' do
    it 'no limit returns 10' do
      expect(json_response.length).to eq(3)
    end

    it 'renders correct data' do
      params[:limit] = 2
      expect(json_response.length).to eq(2)
    end
  end

  describe 'page' do
    it 'no page returns first' do
      expect(json_response[0]['id']).to eq(User.first.id)
    end

    it 'second page returns second' do
      params[:page] = 1 # Zero based index
      params[:limit] = 2 # User list too small otherwise

      expect(json_response[0]['id']).to eq(User.all[2].id)
    end
  end

  describe 'name' do
    it 'no filter returns all' do
      expect(json_response.length).to eq(User.count)
    end

    it 'with filter only relevant' do
      params[:name] = 'Mc'

      expect(response_ids).to match_array(User.where('name LIKE "%Mc%"').pluck(:id))
    end
  end

  describe 'email' do
    it 'no filter returns all' do
      expect(json_response.length).to eq(User.count)
    end

    it 'with filter only relevant' do
      params[:email] = 'xyte'

      expect(response_ids).to match_array(User.where('email LIKE "%xyte%"').pluck(:id))
    end
  end

  describe 'combined' do
    it 'applies all filters and pagination' do
      params[:email] = 'xyte'
      params[:limit] = 1

      expect(response_ids).to match_array(User.where('email LIKE "%xyte%"').limit(1).pluck(:id))
    end
  end
end
