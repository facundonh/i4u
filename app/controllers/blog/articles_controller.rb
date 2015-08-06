class Blog::ArticlesController < Blog::BaseController
  expose(:articles) { site_articles.page(params[:page]).per(3) }
  expose(:rss_feed) { current_site.articles.published.latest_first }
  expose(:article)  { current_site.articles.published.find(params[:id]) }
  expose(:pager)    { ArticlesPager.new(site_articles, article) }

  def index
    @tips = Tip.find(:all, :order => "published_at DESC")
    respond_to do |format|
      format.html
      format.rss  { render layout: false }
    end
  end

  def show; end

protected
  def site_articles
    current_site.articles.published.latest_first
  end
end
