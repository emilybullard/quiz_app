class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  # GET /states
  # GET /states.json
  def index
    @states = State.all
  end

  # GET /states/1
  # GET /states/1.json
  def show
  end

  # GET /states/new
  def new
    @state = State.new
    @states = State.all
  end

  def youwonstates
    @states = State.all 
  end

  # GET /states/1/edit
  def edit
  end

  # POST /states
  # POST /states.json
  def create
    #we're going to be tailoring a message in the case of a wrong or duplicate answer:

@message = ""

 

#your standard new instance of the Resource line:

@state = State.new(state_params)

 

#we'll need this to check if the answer is a duplicate:

@states = State.all

 

#let's make sure the answer is correct, and that it's not a duplicate.

#see the Application Helper for these methods:

correct = check_answer_state(@state.name)

is_dup = check_for_dup_state(@state.name,@states)

 

#we're going to have a couple messages for when the user enters something that is not a city, or is a duplicate answer

if correct == false

@message = "That is not a state TTS is in."

elsif is_dup == true

@message = "You already guessed that one!"

end

 

respond_to do |format|

#if we have > 1 city left to name, and the user's answer is true and not a duplicate answer, we'll save it in the database and redirect back to the same page

if @states.count <= 48 && correct == true && is_dup == false && @state.save

format.html { redirect_to new_state_path, notice: 'State was successfully created.' }

format.json { render action: 'show', status: :created, location: @state }

#if this is our last city to name, and the user's answer is true and not a duplicate answer, we'll save it in the database and redirect to the 'you won!' page

elsif @states.count == 49 && correct == true && is_dup == false && @state.save

format.html { redirect_to youwonstate_path, notice: 'State was successfully created.' }

format.json { render action: 'show', status: :created, location: @state }

else

format.html { render action: 'new' }

format.json { render json: @state.errors, status: :unprocessable_entity }

end

end

end
  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:state).permit(:name)
    end
end
