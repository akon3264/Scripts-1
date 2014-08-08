--Used Malberts Chat Spammer as a basis for this script.  Thanks for the bones Malbert!

require 'utils'
require 'skeys'
local send = require 'SendInputScheduled' -- v09+
local message=""
local delay=100
local times=1
local _registry = {}
local Version=1.0

SpamConfig = scriptConfig("KoolChatz", "KoolChatz Config")
SpamConfig:addParam("hk", "Chat Hotkey", SCRIPT_PARAM_ONKEYDOWN, false, 36)--Home
SpamConfig:addParam("mess", "Spam Message", SCRIPT_PARAM_DOMAINUPDOWN, 1, 35, {"Owned","Help!","Outplayed"}) --Change these to represent what your messages say
SpamConfig:permaShow("mess")

function spamRun()

    if SpamConfig.hk and IsChatOpen()==0 and times==1 then 
        openchat()
        if SpamConfig.mess==1 then
                    send.text("/all GET OWNED KID!")
               elseif SpamConfig.mess==2 then
                    send.text("HELP ME!!")
                elseif SpamConfig.mess==3 then
                    send.text("/all Ouch!!! Out played so hard!")
            end
        times = times + 1
        closechat()

    elseif SpamConfig.hk and IsChatOpen()==1 and times==1 then
        closechat()
        openchat()
        if SpamConfig.mess==1 then
                    send.text("/all GET OWNED KID!")
               elseif SpamConfig.mess==2 then
                    send.text("HELP ME!!")
                elseif SpamConfig.mess==3 then
                    send.text("/all Ouch!!! Out played so hard!")
            end
        closechat()
        times = times + 1

    elseif SpamConfig.hk==false then
        times = 1
    end

    send.tick()
end

function openchat()
    --print('opening_chat')
    send.key_press(0x1c)
    send.wait(delay) -- needed, 100
end
       
       
function closechat()
    --print('closing_chat')
    send.key_press(0x1c)
    send.wait(delay) -- needed, 100
end


function internal_run(t, ...)    
    local fn = t.fn
    local key = t.key or fn
   
    local now = os.clock()
    local data = _registry[key]
       
    if data == nil or t.reset then
        local args = {}
        local n = select('#', ...)
        local v
        for i=1,n do
            v = select(i, ...)
            table.insert(args, v)
        end  
        -- the first t and args are stored in registry        
        data = {count=0, last=0, complete=false, t=t, args=args}
        _registry[key] = data
    end
       
    --assert(data~=nil, 'data==nil')
    --assert(data.count~=nil, 'data.count==nil')
    --assert(now~=nil, 'now==nil')
    --assert(data.t~=nil, 'data.t==nil')
    --assert(data.t.start~=nil, 'data.t.start==nil')
    --assert(data.last~=nil, 'data.last==nil')
    -- run
    local countCheck = (t.count==nil or data.count < t.count)
    local startCheck = (data.t.start==nil or now >= data.t.start)
    local intervalCheck = (t.interval==nil or now-data.last >= t.interval)
    --print('', 'countCheck', tostring(countCheck))
    --print('', 'startCheck', tostring(startCheck))
    --print('', 'intervalCheck', tostring(intervalCheck))
    --print('')
    if not data.complete and countCheck and startCheck and intervalCheck then                
        if t.count ~= nil then -- only increment count if count matters
            data.count = data.count + 1
        end
        data.last = now        
       
        if t._while==nil and t._until==nil then
            return fn(...)
        else
            -- while/until handling
            local signal = t._until ~= nil
            local checker = t._while or t._until
            local result
            if fn == checker then            
                result = fn(...)
                if result == signal then
                    data.complete = true
                end
                return result
            else
                result = checker(...)
                if result == signal then
                    data.complete = true
                else
                    return fn(...)
                end
            end            
        end
    end    
end

SetTimerCallback('spamRun')
