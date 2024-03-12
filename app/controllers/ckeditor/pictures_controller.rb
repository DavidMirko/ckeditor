class Ckeditor::PicturesController < Ckeditor::ApplicationController
  skip_before_action :verify_authenticity_token, only: :create, raise: false

  def index
    @pictures = Ckeditor.picture_adapter.find_all(ckeditor_pictures_scope)
    @pictures = Ckeditor::Paginatable.new(@pictures).page(params[:page])

    respond_to do |format|
      format.html { render layout: @pictures.first_page? }
    end
  end

  def create
    uploaded_file = params[:upload] # Access the uploaded file from the "upload" parameter
    filename = uploaded_file.original_filename # Get the original filename of the uploaded file
    @picture = Ckeditor.picture_model.new # Create a new Picture object
    @picture.assign_attributes(data: uploaded_file, data_file_name: filename) # Set attributes including the filename
    respond_with_asset(@picture)

  end

  def destroy
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to pictures_path }
      format.json { render json: @picture, status: 204 }
    end
  end

  protected

  def find_asset
    @picture = Ckeditor.picture_adapter.get!(params[:id])
  end

  def authorize_resource
    model = (@picture || Ckeditor.picture_model)
    @authorization_adapter.try(:authorize, params[:action], model)
  end
end
