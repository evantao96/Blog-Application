describe 'Comment' do
  let!(:user) { User.create(email: 'user1@test.com', password: 'user1test') }
  let!(:post) { user.posts.create(title: 'new post title', content: 'testing') }
  let!(:comment) { user.comments.create(content: 'new comment1') }

  describe 'belongs_to post' do

    it 'belongs to post' do
      expect { post.comments << comment }.to change(Comment, :count).by 1 
      expect(comment.post).to eq(post)
      expect(post.comments).to include(comment)
    end
    
  end

  describe 'belongs_to user' do

    it 'belongs to user' do
      post.comments << comment
      expect(comment.user).to eq(user)
      expect(user.comments).to include(comment)
    end

  end


  describe 'validations' do

    it 'will not save without content' do
      expect { Comment.create(post: post, user: user) }.to change(Comment, :count).by 0
    end

    it 'will not save without a user' do
      expect { Comment.create(post: post, content: 'new comment') }.to change(Comment, :count).by(0)
    end

    it 'will not save without a post' do
      expect { Comment.create(user: user, content: 'testing') }.to change(Comment, :count).by(0)
    end

  end

end