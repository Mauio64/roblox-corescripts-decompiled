local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local Promise = require(Modules.LuaApp.Promise)
local t1 = {}

function t1.Fetch(p1, p2, p3) -- line: 15
	-- upvalues: PerformFetch (copy), Promise (copy), ArgCheck (copy), t1 (copy), RetrievalStatus (copy)
	return PerformFetch.Single("IXPFetchUserInit" .. tostring(p2) .. tostring(p1), function(p4) -- line: 16
		-- upvalues: p1 (copy), Promise (copy), ArgCheck (copy), p2 (copy), t1 (copy), p3 (copy), PerformFetch (copy), RetrievalStatus (copy)
		if not p1 then
			return Promise.reject()
		end

		ArgCheck.isInTypes(p2, {
			"number",
			"string"
		}, "userId")

		if typeof(p2) == "string" then
			ArgCheck.isNonEmptyString(p2, "userId")
		end

		ArgCheck.assert(t1.IsValidUserIdForIxp(p2), string.format("expects %s to be a number or string representing a positive number!", p2))

		local v18 = tonumber(p2) or 0

		p1:InitializeUserLayers(v18)

		if p1:GetUserLayerLoadingStatus() ~= Enum.IXPLoadingStatus.Pending then
			return Promise.resolve()
		end

		local u19 = nil
		local u20 = false

		return Promise.new(function(resolve, reject) -- line: 41
			-- upvalues: p3 (copy), u20 (ref), PerformFetch (copy), p4 (copy), p2 (copy), p1 (copy), RetrievalStatus (copy), u19 (ref)
			if p3 then
				delay(p3, function() -- line: 43
					-- upvalues: u20 (ref), PerformFetch (copy), p4 (copy), p2 (copy), p1 (copy), RetrievalStatus (copy), u19 (ref), reject (copy)
					if u20 then
						return
					end

					local GetStatus = PerformFetch.GetStatus
					local v24 = p4:getState()
					local v25 = p2
					local v26 = p1
					local v27 = GetStatus(v24, "IXPFetchUserInit" .. tostring(v25) .. tostring(v26))

					if v27 ~= RetrievalStatus.Done and v27 ~= RetrievalStatus.Failed then
						if u19 then
							u19:disconnect()
							u19 = nil
						end

						reject()
					end
				end)
			end

			u19 = p1.OnUserLayerLoadingStatusChanged:Connect(function(_) -- line: 59
				-- upvalues: p1 (copy), u20 (ref), u19 (ref), resolve (copy)
				if p1:GetUserLayerLoadingStatus() ~= Enum.IXPLoadingStatus.Pending then
					u20 = true

					if u19 then
						u19:disconnect()
						u19 = nil
					end

					resolve()
				end
			end)
		end)
	end)
end
function t1.GetFetchingStatus(p6, p7, p8) -- line: 74
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p6, "IXPFetchUserInit" .. tostring(p7) .. tostring(p8))
end
function t1.IsValidUserIdForIxp(p9) -- line: 78
	return p9 ~= nil and (p9 ~= "" and (p9 ~= "-1" and (p9 ~= "0" and (p9 ~= -1 and p9 ~= 0))))
end

return t1
