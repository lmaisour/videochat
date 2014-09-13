class RoomsController < ApplicationController
  before_action :config_opentok, :except => [:index]

  def index
    @rooms = Room.where(public: true)
    @new_room = Room.new
  end

 def create
    session = @opentok.create_session
    params[:room][:sessionId] = session.session_id

    # session_id = session.session_id
    # binding.pry
    # request.remote_addr
    # params[:room][:sessionId] = session.session_id

    @new_room = Room.new(room_params)

    if @new_room.save
        redirect_to("/show/"+@new_room.id.to_s) 
    else
        redirect_to root_path 
    end

end
  
  def show
    # begin
        @room = Room.find(params[:id])
        @tok_token = @opentok.generate_token @room.sessionId
    # rescue
    #   flash[:notice] = "some shit went wrong son"
    #   redirect_to :action => :index
    # end
end

  private

  def config_opentok
    if @opentok.nil?
        @opentok = OpenTok::OpenTok.new "44979352", "c4b975eed97c2f85866bdc289904ddb84a842a56"
    end
  end

  def room_params
    params.require(:room).permit(:sessionId, :name, :public)
  end


end