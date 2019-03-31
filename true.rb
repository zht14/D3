require "sinatra"
require 'sinatra/reloader'

valid=false
check_nil=true

true_value="T"
false_value="F"
size_blocks=3
input_string=""

rows=0
hm=Hash.new

def check_valid(true_v, false_v, size)
    if(true_v .eql? false_v || true_v.size!=1 || false_v.size!=1 || size.size!=1)
        return false
    elsif(size[0].to_f<2 || size[0].to_f != size[0].to_i)
        return false
    end
    
    return true
end

def default_setting_t
   "T"
end

def default_setting_f
   "F"
end

def default_setting_s
   "3"
end
    
def get_rows size_blocks
    row=2
    for i in 1...size_blocks.to_i
        row*=2
    end
    row
end

def hash_table rows, size_blocks, true_value, false_value
    t_numbers=0
    input_string=""
    array=Array.new(size_blocks.to_i)
    
    for i in 0...size_blocks.to_i
        array[i]=true_value
    end
    
    hm=Hash.new
    
    for i in 1..rows
        for j in (0...size_blocks.to_i).to_a.reverse
            if array[j] == true_value
                t_numbers+=1
            end
            if i% (2**j)==0
                input_string+=array[j]
                if array[j]==true_value
                    array[j]=false_value
                elsif array[j]==false_value
                    array[j]=true_value
                end
            else
                input_string+=array[j]
            end
        end
        if t_numbers==size_blocks.to_i
            input_string+=true_value
        else
            input_string+=false_value
        end
        
        if t_numbers >=1
            input_string+=true_value
        else
            input_string+=false_value
        end
        
        if t_numbers<size_blocks.to_i
            input_string+=true_value
        else
            input_string+=false_value
        end
        
        if t_numbers==0
            input_string+=true_value
        else
            input_string+=false_value
        end
        
        if t_numbers%2==0
            input_string+=false_value
        else
            input_string+=true_value
        end
        
        if t_numbers==1
            input_string+=true_value
        else
            input_string+=false_value
        end
        
        hm[i-1]=input_string
        t_numbers=0
        input_string=""
    end
    hm
        
end
    

get "/" do
    
    true_value=params['true']
    false_value=params['false']
    size_blocks=params['size']
    
    if true_value.nil? && false_value.nil? && size_blocks.nil?
        check_nil=true
        valid=false
    else
        check_nil=false
        valid=check_valid true_value, false_value, size_blocks
    end
    
     
    if !check_nil
        if true_value.size==0 && false_value.size==0 && size_blocks.size==0
            true_value=default_setting_t
            false_value=default_setting_f
            size_blocks=default_setting_s
            valid=true
            
        end
    end
    
    if(!check_nil && valid)
        rows=get_rows size_blocks
        hm=hash_table rows, size_blocks,true_value, false_value
    end
       
    erb :index, :locals => { valid: valid, check_nil: check_nil, true_value: true_value, false_value: false_value, size_blocks: size_blocks.to_i, rows: rows, hm: hm}
end




not_found do
    status 404
    erb :error
end