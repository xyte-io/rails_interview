describe CommentsController, type: :controller do
  let(:params) { {} }
  let(:json_response) { JSON.parse(subject.body) }
  let(:response_ids) { json_response.map { |r| r['id'] } }

  subject do
    get :index, params: params

    response
  end

  describe 'limit' do
    it 'no limit returns 10' do
      expect(json_response.length).to eq(10)
    end

    it 'renders correct data' do
      params[:limit] = 5
      expect(json_response.length).to eq(5)
    end
  end

  describe 'page' do
    it 'no page returns first' do
      expect(json_response[0]['id']).to eq(Comment.first.id)
    end

    it 'second page returns second' do
      params[:page] = 1 # Zero based index

      expect(json_response[0]['id']).to eq(Comment.all[10].id)
    end
  end

  describe 'content' do
    it 'no filter returns all' do
      expect(response_ids).to match_array(Comment.first(10).pluck(:id))
    end

    it 'with filter only relevant' do
      params[:content] = 'am'

      expect(response_ids).to match_array(Comment.where('content LIKE "%am%"').first(10).pluck(:id))
    end
  end

  describe 'user name' do
    it 'no filter returns all' do
      expect(response_ids).to match_array(Comment.first(10).pluck(:id))
    end

    it 'with filter only relevant' do
      params[:user_name] = 'McCow'

      expect(response_ids).to match_array(Comment.joins(:user).where('users.name LIKE "%McCow%"').first(10).pluck(:id))
    end
  end

  describe 'user email' do
    it 'no filter returns all' do
      expect(response_ids).to match_array(Comment.first(10).pluck(:id))
    end

    it 'with filter only relevant' do
      params[:user_email] = 'google'

      expect(response_ids).to match_array(Comment.joins(:user).where('users.email LIKE "%google%"').first(10).pluck(:id))
    end
  end

  describe 'combined' do
    it 'applies all filters and pagination' do
      params[:user_email] = 'xyte'
      params[:content] = 'You'
      params[:page] = 1
      params[:limit] = 3

      expected = Comment.joins(:user)
                        .where('users.email LIKE "%xyte%"')
                        .where('content LIKE "%You%"')
                        .offset(3)
                        .first(3)

      expect(response_ids).to match_array(expected.pluck(:id))
    end
  end
end
