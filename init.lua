-- xFix Lua

	-- Name: XFix
	-- 
	-- Author: Grimmier
	-- Purpose: fix stuck xtarget slots that will break automation. Sometimes these are empty slots other times they are corpses.
	-- Scans xtarg list every second. if we are not in combat and there is a stuck slot we pop it and set it back to autohater.

---@type Mq
local mq = require('mq')
local PAUSED = false
local DEBUG = false
local RUNNING = true
local version = 1.5
local function debug(string)
    if(DEBUG) then print(string.format('\aoxFix::\aoDEBUG::\at %s',tostring(string))) end
end
local function help()
	print('\ayxFix::\a-o xFix Command List:')
	print('\ayxFix::\ag /xfix pause \at Toggles Pause on and off')
	print('\ayxfix::\ag /xfis debug \at Turn on and off Debug Spam')
	print('\ayxFix::\ag /xfix stop \at Ends the script')
	print('\ayxFix::\ag /xfix help \at Lists this command list')
end
local function bind(...)
    local args = {...}
    local key = args[1]
    local value = args[2]
    if key == 'pause' then
       	if PAUSED then 
			PAUSED = false
			print('\ayxFix::\ag xFix Resuming...')
		else
			PAUSED = true
			print('\ayxFix::\ao xFix Paused!')
		end
	elseif key == 'debug' then
        if DEBUG then
			 DEBUG = false 
      	  	print('\ayxFix::\ao Debug Spam Disabled!')
		else
			DEBUG = true
			print('\ayxFix::\ag Debug Spam Enabled!')
		end
	elseif key == 'help' or not key then
		help()
    elseif key == 'stop' then
		RUNNING = false
	end
end
local function ScanXtar()
	if mq.TLO.Me.XTarget() > 0 then
		for i = 1, 20 do
			local xName = mq.TLO.Me.XTarget(i).Name() or 'NULL'
			local xHp = mq.TLO.Me.XTarget(i).PctHPs() or -1
			local xId = mq.TLO.Me.XTarget(i).ID() or -1
			local xType = mq.TLO.Me.XTarget(i).Type() or '?'

			if (mq.TLO.Me.XTarget() > 0 and xId == 0) or xType == 'Corpse' then
				if ((xName ~= 'NULL' and xId == 0) or xType == 'Corpse') then
					mq.cmd('/squelch /xtarg set '..i..' ET')
					mq.delay(100)
					mq.cmd('/squelch /xtarg set '..i..' AH')
				local debugString = ' Cleaning Xtarget Slot:: '..i..' Name:: '..xName..' Type:: '..xType
				if DEBUG then debug(debugString) end
				end
			else
				break
			end
		end
	end
end
local function init()
	print('\ayxFix::\ag LOADING \ayxFix::Version::\ag'..tostring(version))
	mq.bind('/xfix', bind)
	help()
end
local function loop()
	while RUNNING do
		if not PAUSED then
			if mq.TLO.Me.CombatState() ~= 'COMBAT' then ScanXtar() end
		end
		mq.delay('1s')
	end
end
init()
loop()
