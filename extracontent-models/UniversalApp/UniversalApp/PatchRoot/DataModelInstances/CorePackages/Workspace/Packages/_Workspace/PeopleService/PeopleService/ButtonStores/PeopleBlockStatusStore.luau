local PeopleService = script:FindFirstAncestor("PeopleService")
local PeopleServiceParent = PeopleService.Parent
local Players = game:GetService("Players")
local Signals = require(PeopleServiceParent.Signals)
local BlockingUtility = require(PeopleServiceParent.BlockingUtility)
local Constants = require(PeopleService.Constants)
local PeopleBlockingModalManager = require(PeopleService.Integration.PeopleBlockingModalManager)
local PeopleAnalyticsManager = require(PeopleService.Analytics.PeopleAnalyticsManager)
local GetFFlagAddPeoplePageCardLayout = require(PeopleService.Flags).GetFFlagAddPeoplePageCardLayout

local function createPeopleBlockStatusStore() -- line: 31
	-- upvalues: Signals (copy), BlockingUtility (copy), PeopleBlockingModalManager (copy), GetFFlagAddPeoplePageCardLayout (copy), Constants (copy), Players (copy), PeopleAnalyticsManager (copy)
	local t1 = {}
	local connection = nil

	local function onBlockStatusChanged(n1: number, b1: boolean) -- line: 66
		-- upvalues: t1 (ref)
		if t1[n1] then
			t1[n1].setter(b1)
		end
	end
	local function initializeBlockStatusListener() -- line: 120
		-- upvalues: BlockingUtility (copy), connection (ref), onBlockStatusChanged (copy)
		connection = BlockingUtility:GetBlockedStatusChangedEvent():Connect(onBlockStatusChanged)
	end

	connection = BlockingUtility:GetBlockedStatusChangedEvent():Connect(onBlockStatusChanged)

	return {
		getPlayerBlockStatus = function(n2: number) -- line: 39
			-- upvalues: Signals (copy), t1 (ref), BlockingUtility (copy)
			if not n2 then
				return Signals.createSignal(false)
			end

			if t1[n2] then
				return t1[n2].getter
			end

			local v16 = BlockingUtility:IsPlayerBlockedByUserId(n2)
			local v17, v18 = Signals.createSignal(v16)

			t1[n2] = {
				getter = v17,
				setter = v18
			}

			return v17
		end,
		unblockPlayer = function(p1, s1: string?) -- line: 95
			-- upvalues: BlockingUtility (copy), Players (copy), PeopleAnalyticsManager (copy), GetFFlagAddPeoplePageCardLayout (copy), t1 (ref)
			if not p1 then
				return
			end

			if BlockingUtility:UnblockPlayerAsync(p1) then
				local LocalPlayer = Players.LocalPlayer

				if LocalPlayer then
					PeopleAnalyticsManager:trackUnblockUser(p1.UserId, LocalPlayer.UserId, if not GetFFlagAddPeoplePageCardLayout() then nil else s1)
				end

				if t1[p1.UserId] then
					t1[p1.UserId].setter(false)
				end
			end
		end,
		blockPlayer = function(p2, s2: string?) -- line: 73
			-- upvalues: t1 (ref), PeopleBlockingModalManager (copy), GetFFlagAddPeoplePageCardLayout (copy), Constants (copy)
			local t2 = {
				onBlockingSuccess = function() -- line: 75
					-- upvalues: t1 (ref), p2 (copy)
					if t1[p2.UserId] then
						t1[p2.UserId].setter(true)
					end
				end
			}
			local v24 = PeopleBlockingModalManager.openModal(p2, if not GetFFlagAddPeoplePageCardLayout() then Constants.ANALYTICS.IN_GAME_MENU_NAME else s2, t2)

			if v24 then
				v24:catch(function(p3) -- line: 88
					warn("Block modal promise error:", p3)
				end)
			end
		end,
		cleanup = function() -- line: 126
			-- upvalues: connection (ref), t1 (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			t1 = {}
		end
	}
end

return (createPeopleBlockStatusStore())
