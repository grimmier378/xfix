-- xFix Lua

	-- Name: XFix
	-- Version: 1.2
	-- Author: Grimmier
	-- Purpose: fix stuck xtarget slots that will break automation. Sometimes these are empty slots other times they are corpses.
	-- Scans xtarg list every second. if we are not in combat and there is a stuck slot we pop it and set it back to autohater.

---@type Mq
local mq = require('mq')

local function ScanXtar()
	if mq.TLO.Me.XTarget() > 0 then
		for i = 1, 20 do
			local xName = mq.TLO.Me.XTarget(i).Name() or 'NULL'
			local xHp = mq.TLO.Me.XTarget(i).PctHPs() or -1
			local xId = mq.TLO.Me.XTarget(i).ID() or -1
			local xType = mq.TLO.Me.XTarget(i).Type() or '?'

			if mq.TLO.Me.XTarget() > 0 and xId == 0 then
				if ((xName ~= 'NULL' and xId == 0 ) or xType == 'Corpse') then
					mq.cmd('/squelch /xtarg set '..i..' ET')
					mq.delay(100)
					mq.cmd('/squelch /xtarg set '..i..' AH')
				--	print(':: xFix :: Cleaning Xtarget Slot:: '..i..' Name:: '..xName..' Type:: '..xType)
				end
			else
				break
			end
		end
	end
end
local function loop()
	while true do
		if mq.TLO.Me.CombatState() ~= 'COMBAT' then ScanXtar() end
		mq.delay('1s')
	end
end
loop()
