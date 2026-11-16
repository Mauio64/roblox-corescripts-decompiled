local PeopleService = script:FindFirstAncestor("PeopleService")
local parent = PeopleService.Parent

local Players = game:GetService("Players")

local Signals = require(parent.Signals)
local BlockingUtility = require(parent.BlockingUtility)

local Constants = require(PeopleService.Constants)

local PeopleBlockingModalManager = require(PeopleService.Integration.PeopleBlockingModalManager)
local PeopleAnalyticsManager = require(PeopleService.Analytics.PeopleAnalyticsManager)

local Flags = require(PeopleService.Flags)
local GetFFlagAddPeoplePageCardLayout = Flags.GetFFlagAddPeoplePageCardLayout

local function createPeopleBlockStatusStore()
	local v = {}

	local connection = nil

	local function getPlayerBlockStatus(p: number)
		if not p then
			return Signals.createSignal(false)
		end

		if v[p] then
			return v[p].getter
		end

		local isPlayerBlockedByUserId = BlockingUtility:IsPlayerBlockedByUserId(p)

		local signal, setter = Signals.createSignal(isPlayerBlockedByUserId)

		v[p] = { getter = signal, setter = setter }

		return signal
	end

	local function onBlockStatusChanged(p: number, flag: boolean)
		if v[p] then
			v[p].setter(flag)
		end
	end

	local function blockPlayer(p, p2: string?)
		local v2 = {
			onBlockingSuccess = function()
				if v[p.UserId] then
					v[p.UserId].setter(true)
				end
			end
		}

		local openModal = PeopleBlockingModalManager.openModal

		if not GetFFlagAddPeoplePageCardLayout() then
			p2 = Constants.ANALYTICS.IN_GAME_MENU_NAME
		end

		local v3 = openModal(p, p2, v2)

		if v3 then
			v3:catch(function(p3)
				warn("Block modal promise error:", p3)
			end)
		end
	end

	local function unblockPlayer(p, p2: string?)
		if not p then
			return
		end

		if BlockingUtility:UnblockPlayerAsync(p) then
			local localPlayer = Players.LocalPlayer

			if localPlayer then
				local userId = p.UserId
				local userId2 = localPlayer.UserId

				if not GetFFlagAddPeoplePageCardLayout() then
					p2 = nil
				end

				PeopleAnalyticsManager:trackUnblockUser(userId, userId2, p2)
			end

			if v[p.UserId] then
				v[p.UserId].setter(false)
			end
		end
	end

	local function initializeBlockStatusListener() -- 1 equivalent call inferred from this helper
		connection = BlockingUtility:GetBlockedStatusChangedEvent():Connect(onBlockStatusChanged)
	end

	local function cleanup()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		v = {}
	end

	initializeBlockStatusListener() -- inferred equivalent call
	return {
		getPlayerBlockStatus = getPlayerBlockStatus,
		unblockPlayer = unblockPlayer,
		blockPlayer = blockPlayer,
		cleanup = cleanup
	}
end

return createPeopleBlockStatusStore()
