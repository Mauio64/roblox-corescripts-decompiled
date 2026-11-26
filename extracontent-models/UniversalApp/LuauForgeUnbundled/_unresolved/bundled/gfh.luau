local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzO")
local module2 = require("@luauforge/bundled/egs")

local v5 = {}

function v5.Fetch(object, value, p2)
	return performFetch.Single("IXPFetchUserInit" .. tostring(value) .. tostring(object), function(object2)
		if not object then
			return module2.reject()
		end

		module.isInTypes(value, { "number", "string" }, "userId")

		if typeof(value) == "string" then
			module.isNonEmptyString(value, "userId")
		end

		module.assert(
			v5.IsValidUserIdForIxp(value),
			string.format("expects %s to be a number or string representing a positive number!", value)
		)

		object:InitializeUserLayers(tonumber(value) or 0)

		if object:GetUserLayerLoadingStatus() ~= Enum.IXPLoadingStatus.Pending then
			return module2.resolve()
		end

		local onUserLayerLoadingStatusChangedConnection = nil
		local flag = false

		return module2.new(function(callback, callback2)
			if p2 then
				delay(p2, function()
					if flag then
						return
					end

					local status = performFetch.GetStatus(
						object2:getState(),
						"IXPFetchUserInit" .. tostring(value) .. tostring(object)
					)

					if status ~= retrievalStatus.Done and status ~= retrievalStatus.Failed then
						if onUserLayerLoadingStatusChangedConnection then
							onUserLayerLoadingStatusChangedConnection:disconnect()
							onUserLayerLoadingStatusChangedConnection = nil
						end

						callback2()
					end
				end)
			end

			onUserLayerLoadingStatusChangedConnection = object.OnUserLayerLoadingStatusChanged:Connect(function(p3)
				if object:GetUserLayerLoadingStatus() ~= Enum.IXPLoadingStatus.Pending then
					flag = true

					if onUserLayerLoadingStatusChangedConnection then
						onUserLayerLoadingStatusChangedConnection:disconnect()
						onUserLayerLoadingStatusChangedConnection = nil
					end

					callback()
				end
			end)
		end)
	end)
end

function v5.GetFetchingStatus(p2, p3, p4)
	return performFetch.GetStatus(p2, "IXPFetchUserInit" .. tostring(p3) .. tostring(p4))
end

function v5.IsValidUserIdForIxp(p2): boolean
	return p2 ~= nil and p2 ~= "" and p2 ~= "-1" and p2 ~= "0" and p2 ~= -1 and p2 ~= 0
end

return v5
