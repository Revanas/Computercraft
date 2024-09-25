-- USAGE: boxCutter(distForward, distRight, distUp)
-- by aijada bosatsu, July 2019
-- dig rectangular shapes even out of solid rock
-- place on ground against future box. will cut in, 
-- then work from top down, cutting rightward
-- https://pastebin.com/Fkw3hWeK

-- variables
local args = {...}
local distFWD = 0
local distRGT = 0
local distUP = 0
local height = 1
local heightApparent = 1 
local facing = 1
local panic = false
local attack = false

-- functions
function init()
  if #args ~= 3 then
    term.setTextColour(colours.lightBlue)
    print ("Must pass arguments")
    print ("(forward depth, distance right, height)")
    term.setTextColour(colours.white)
    return false
  else
    distFWD = (args[1]-1)
    distRGT = (args[2]-1)
    distUP  = tonumber((args[3]))
    if distUP%2 ~= 0 then
      heightApparent = heightApparent + 1
      -- odd-numbered height confuses chicane/curve
      -- would make turtle cut room leftward
    end
    local volume = args[1] * args[2] * distUP
    print ("Cutting " .. volume .. " cubic metres")
    return true
  end
end

function up()
  while not turtle.up() do turtle.digUp() sleep(0.3) end
	height = height + 1
	heightApparent = heightApparent + 1
end

function down()
	while not turtle.down() do turtle.digDown() end
	height = height -1
	heightApparent = heightApparent - 1
end

function forward()
	while not turtle.forward() do turtle.attack() turtle.dig() end
end

function right()
  turtle.turnRight()
  facing = facing + 1
  if facing > 4 then facing = 1 end
end
 
function left()
  turtle.turnLeft()
  facing = facing - 1
  if facing < 1 then facing = 4 end
end

function hairpin()
	right() right()
end

function straightaway()
	for f = 1, distFWD do forward() end
end

function chicane()
	if facing == 1 then
		right() forward() right()
	elseif facing == 3 then
		left() forward() left()
	else
		panic = true  -- i'm lost!
    attack = "Chicane Spinout!!"
	end
end

function curve()
	if facing == 1 then
		left() forward() left()
	elseif facing == 3 then
		right() forward() right()
	else
		panic = true  -- i'm lost!
    attack = "Curved into the Wall \:\("
	end
end

function returnToPits()
-- if last straightaway took it away
-- return to initial starting point
  if facing == 3 then
	  straightaway()
	end
end

-- Main()
if init() then 
	forward()
	-- manouevre to top plane
	while height < distUP do up()	end
	for h = 1, distUP do		-- vertical slice loop
		for r = 1, distRGT do -- rightward loop
			straightaway()
			if heightApparent%2==0 then
				chicane()
			else
				curve()
			end
			if panic then break	end
    end  
		if panic then 
			print("Panic = "..panic)
      print("Attack = "..attack)
      break
		end
		straightaway() -- finish last row
		hairpin()
		if height > 1 then down()	end
	end	 
	returnToPits()
else
	print("Init failed")
end
