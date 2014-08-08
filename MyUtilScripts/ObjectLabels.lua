-- draw all object labels: charName & name, at their position
-- multiple objects at the same coordinate are drawn on multiple lines
-- also appends all charName, name and positions to _objects.txt on load
--
-- see also iger's particle and object detector
--
-- lb problems: garbage names, objects disappear from list unexpectedly, drawing
--
-- v01 - 5/24/2013 5:18:25 PM - initial release, only tested on jit

local max_labels_to_draw = 400

function LogObjects(output)    
    for i = 1, objManager:GetMaxObjects() do
        local o = objManager:GetObject(i)
        if IsValidObject(o) then
            local char, name = '', ''
            if IsStringToLog(o.charName) then
                char = o.charName
            end
            if IsStringToLog(o.name) then
                name = o.name
            end
            if char ~= '' or name ~= '' then
                output:write(string.format('%s ; %s ; %d, %d, %d\n', char, name, o.x, o.y, o.z))
            end
        end
    end
end

local once = true
local drawq = {}
local drawq_objects = {}
local label_count = 0
function Tick()
    if once then
        local output = io.open('_objects.txt', 'a+')
        LogObjects(output)
        output:close()
        once = false        
    end

    local lines = {}
    table.insert(lines, string.format('new objects: %d', objManager:GetMaxNewObjects()))
    table.insert(lines, string.format('labels: %d', label_count))
    DrawTextLines(lines, 600, 50, 0xFF00FF00)

    label_count = 0
    drawq = {}
    drawq_objects = {}
    for i = 1, objManager:GetMaxObjects() do
        local o = objManager:GetObject(i)
        if IsValidObject(o) then
            local char, name = '', ''
            if IsStringToDraw(o.charName) then
                char = o.charName
            end
            if IsStringToDraw(o.name) then
                name = o.name
            end
            if (char ~= '' or name ~= '') and label_count < max_labels_to_draw then
                local key = string.format('%g,%g,%g', o.x, o.y, o.z)
                local s = string.format('%s / %s', char, name)
                if drawq[key] == nil then
                    drawq[key] = {}
                    drawq_objects[key] = o
                    label_count = label_count + 1
                end
                table.insert(drawq[key], s)
            end
        end
    end
    for k,v in pairs(drawq) do
        local o = drawq_objects[k]
        local s = table.concat(v,'\n')
        DrawTextObject(s, o, 0xFF7FFF88)
    end    
end

function DrawTextLines(lines,x,y,color)
    local s = table.concat(lines,'\n')
    DrawText(s, x, y, color)
end

function IsValidObject(obj)    
    return obj ~= nil
end

function StartsWith(s, sub)
    return s:sub(1,string.len(sub))==sub
end

function IsStringToDraw(s)
    if s == nil or s=='' or string.len(s) < 4 then return false end
    return string.match(s,'^[%w_.]*$') ~= nil
end

function IsStringToLog(s)
    if s == nil or s=='' or string.len(s) < 8 then return false end
    if not string.find(s, '.', 1, true) then return false end
    if string.match(s:sub(1,1),'[A-Z]') or StartsWith(s,'global') then 
        -- allow capitalized words or good prefix
    else
        return false
    end    
    return string.match(s,'^[%w_.]*$') ~= nil
end

SetTimerCallback('Tick')
