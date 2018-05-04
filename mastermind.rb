require 'sinatra'
require 'sinatra/reloader' if development? 
# define base colors
# red, green, blue, yellow, brown, white, black... more?
# array probably called game


set :color, "#FF0000"
@@colors =['red','green','blue','yellow','brown','pink','purple']
@@guesses =6
@@message =""
@@cheat =""
@@guessesmaster = []
@@master = [@@colors.sample,@@colors.sample,@@colors.sample,@@colors.sample]
#/
get '/' do
    game = @@master
    black =0
    white =0
    if(!params["pos1"].nil?)
        if(params["pos1"]==game[0])
            black+=1
        elsif((params["pos1"]==game[1]) or (params["pos1"]==game[2]) or (params["pos1"]==game[3]))
            white+=1
        end
    end
    if(!params["pos2"].nil?)
        if(params["pos2"]==game[1])
            black+=1
        elsif((params["pos2"]==game[0]) or (params["pos2"]==game[2]) or (params["pos2"]==game[3]))
            white+=1
        end
    end
    if(!params["pos3"].nil?)
        if(params["pos3"]==game[2])
            black+=1
        elsif((params["pos3"]==game[0]) or (params["pos3"]==game[1]) or (params["pos3"]==game[3]))
            white+=1
        end
    end
    if(!params["pos4"].nil?)
        if(params["pos4"]==game[3])
            black+=1
        elsif((params["pos4"]==game[0]) or (params["pos4"]==game[1]) or (params["pos4"]==game[2]))
            white+=1
        end
    end
    guess=[params["pos1"],params["pos2"],params["pos3"],params["pos4"],white,black]

    if(!params["pos1"].nil?)
        @@guessesmaster.push(guess)
    else
        @@guessesmaster=[]
        @@master = [@@colors.sample,@@colors.sample,@@colors.sample,@@colors.sample]
    end

    erb :index, :locals => {:guesses => @@guessesmaster.length}
end


def check_guess guess
    answer = ""
    @@guesses -= 1
    diff = guess.to_i-settings.number
    if(diff.abs>15)
        settings.color="#ff0000"
    else
        settings.color = "#"+diff.abs.to_s(16)+diff.abs.to_s(16)+(15-diff.abs).to_s(16)+(15-diff.abs).to_s(16)+"00"
    end
    if(diff.abs>5)
        answer = "way "
    end
    if diff<0
        answer = answer + "too low"
    elsif diff>0
        answer = answer + "too high"
    else
        answer="You guessed right"
        @@message="A new number is generated"
        settings.number = rand(100)
        @@guesses =6
    end
    answer
end