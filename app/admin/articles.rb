ActiveAdmin.register Article do

  filter :site

  index do
    column ("Site") { |article| article.site.name }
    column ("Author"), sortable: :author do |article|
      article.author
    end
    column ("Title"), sortable: :title do |article|
      article.title 
    end
    column ("Subtitle"), sortable: :subtitle do |article|
      article.subtitle
    end
    column 'Image' do |article|
      if article.image.present?
        image_tag article.image, size: '50x50'
      else 
        ''
      end
    end
    column ("Summary"), sortable: :summary do |article|
      truncate article.summary, length: 100
    end
    column ("Publication State"), sortable: :publication_state do |article|
      check_state(article.publication_state)
    end
    column ("Tag List") do |article|
      article.tag_list
    end

    default_actions
  end

  show do
    attributes_table do
      row "Site" do |article|
        article.site.name
      end
      row :author
      row :title
      row :subtitle
      row :description do |article|
        textilize(article.description)
      end
      row :image do |article|
        if article.image.present?
          image_tag article.image.url(:small)
        else 
          ''
        end
      end
      row :summary
      row :content do |article|
        textilize(article.content)
      end
      row :publication_state do |article|
        check_state(article.publication_state)
      end
      row :publication_date
      row :tag_list
    end
  end

  form do |f|
    f.inputs "Edit News" do
      f.input :site_id, :label => "Site",
              :as => :select, :collection => Hash[Site.all.map{|s| [s.name, s.id]}]
      f.input :author
      f.input :title
      f.input :subtitle
      f.input :description, hint: "description its shown in home page"
      f.input :image, label: 'Hightligh Image', 
        hint: (f.object.new_record? ? "" : f.object.image.url), as: :file
      f.input :content
      f.input :summary, hint: "summary its show in blog"
      f.input :publication_state, label: 'Publication state', as: :select,
        collection: [['Draft',0],['Published',1]]
      f.input :publication_date
      f.input :tag_list
    end

    f.buttons
  end

  controller do
    def resource_params
      return [] if request.get?
      [ params.require(:article)
        .permit(:site_id,:author, :title, :content,:subtitle,
         :summary, :publication_date, :publication_state,
         :image,:description, :tag_list) ]
    end
  end

end