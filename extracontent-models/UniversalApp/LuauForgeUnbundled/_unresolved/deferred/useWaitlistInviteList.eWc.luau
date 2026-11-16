local module = require("@luauforge/deferred/eWd")
local module2 = require("@luauforge/deferred/egU")
local module3 = require("@luauforge/deferred/eUP")
local module4 = require("@luauforge/deferred/ehf")
local module5 = require("@luauforge/deferred/ehe")
local module6 = require("@luauforge/deferred/eVf")
local localUserIdStore = require("@luauforge/deferred/ehg").LocalUserIdStore
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module7 = require("@luauforge/deferred/eUy")
local module8 = require("@luauforge/deferred/egW")
local module9 = require("@luauforge/deferred/ehb")
require("@luauforge/deferred/egX")
local module10 = require("@luauforge/deferred/eVh")
local module11 = require("@luauforge/deferred/eUF")

local module12 = require("@luauforge/deferred/eWe")

local useDispatch = module3.Hooks.RoactRodux.useDispatch
local useSignalState = module5.useSignalState
local useBatchedImpressions = module.useBatchedImpressions

local eventNames = module7.EventNames

local frozen = table.freeze({})

local function mapImpressionItem(p2, p3, p4)
	return { userId = p2, position = p3 }
end

local function useWaitlistInviteList()
	local v5 = useSignalState(localUserIdStore.getCurrentUserId)

	if v5 == "" then
		v5 = nil
	end

	local v6 = module10(false)
	local v7 = useDispatch()

	local v8 = useLocalization({ somethingWentWrong = module9.SomethingWentWrong })

	local v9 = module2.useMemo(function()
		if v5 == nil then
			return nil
		end

		return (v6.getInviteCandidates(v5))
	end, { v6, v5 })

	local v10 = useSignalState((module2.useMemo(function()
		return module4.createComputed(function(p2)
			local v11 = if v9 then v9.data(p2) else nil

			if v11 == nil then
				return frozen
			end

			local sends = v6.getSends(p2)
			local result = table.create(#v11)

			for k, v12 in v11 do
				local send = sends[v12.userId]
				local status = if send then send.status else nil
				local v13 = { userId = v12.userId, status = 0 }
				local v14

				if v12.invited or status == module8.InviteSendStatus.Sent then
					v14 = module8.InviteRowStatus.Invited
				elseif status == module8.InviteSendStatus.Sending then
					v14 = module8.InviteRowStatus.Sending
				else
					v14 = module8.InviteRowStatus.Invite
				end

				v13.status = v14
				table.insert(result, v13)
			end

			return result
		end)
	end, { v9, v6 })))

	local v11 = module7.useSchoolsAnalytics()
	local v12

	if module11 then
		v12 = useBatchedImpressions({
			batchTimeMs = module12,
			mapItem = mapImpressionItem,
			onFlush = function(list, p2)
				local userIds = table.create(#list)
				local positions = table.create(#list)

				for k, item in list do
					table.insert(userIds, item.userId)
					table.insert(positions, (tostring(item.position)))
				end

				v11(eventNames.WaitlistInviteImpression, {
					userIds = table.concat(userIds, ","),
					positions = table.concat(positions, ",")
				})
			end
		})
	end

	local v13 = {
		rows = v10,
		onInvite = module2.useCallback(function(p2, p3)
			if module11 then
				v11(eventNames.WaitlistInviteClick, { targetUserId = p2, position = p3 })
			end

			v6.sendInvite(p2):catch(function()
				v7(module6.Actions.SetCurrentToastMessage({
					toastMessage = v8.somethingWentWrong,
					isLocalized = true
				}))
			end)
		end, { v6, v7, v8.somethingWentWrong, v11 }),
		onImpression = 0
	}

	local v14 = if v12 then v12.addImpression else nil
	v13.onImpression = v14
	return v13
end

return useWaitlistInviteList
