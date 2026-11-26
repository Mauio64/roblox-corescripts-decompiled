local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local getAssetUserAuthStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AssetUserAuth").getAssetUserAuthStore

local Debug = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat").debug

local formatError = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/formatError")

local function useMediaUpdater(p2)
	local ref = React.useRef(Promise.resolve())
	local onSuccess = p2 and p2.onSuccess
	local onError = p2 and p2.onError

	local v5 = React.useCallback(function(p3, p4)
		Debug.log("info", `media_updater {p4} enqueued`)
		local v6 = ref.current:catch(function(): nil
			return nil
		end):andThen(p3):andThen(function(p5)
			return getAssetUserAuthStore().pollUntilDone(p5)
		end):andThen(function(p5)
			if typeof(p5) == "table" and p5.status == "timed_out" then
				return Promise.reject("Operation did not complete in time")
			end

			if p5.status == "done" then
				return p5.operation
			end

			return p5
		end)

		ref.current = v6:catch(function(): nil
			return nil
		end)

		return v6:andThen(function(p5)
			Debug.log("info", `media_updater {p4} succeeded`)

			if onSuccess then
				onSuccess()
			end

			return p5
		end):catch(function(p5)
			local v7 = formatError(p5)
			Debug.log("warn", `media_updater {p4} failed`, { error = v7 })

			if onError then
				onError(v7)
			end

			return Promise.reject(p5)
		end)
	end, { onSuccess, onError })

	return {
		setIcon = React.useCallback(function(p3, p4)
			return v5(function()
				return Promise.resolve(p4):andThen(function(p5)
					return getAssetUserAuthStore().updateIcon(p3, p5)
				end)
			end, "setIcon")
		end, { v5 }),
		addPreview = React.useCallback(function(p3, p4)
			return v5(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return Promise.resolve(p4):andThen(function(p5)
					return assetUserAuthStore.getPreviews(p3):andThen(function(p6)
						local clone = table.clone(p6)
						table.insert(clone, { asset = `assets/{p5}` })
						return assetUserAuthStore.updatePreviews(p3, clone)
					end)
				end)
			end, "addPreview")
		end, { v5 }),
		replacePreview = React.useCallback(function(p3, p4, p5)
			return v5(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return Promise.resolve(p4):andThen(function(p6)
					return assetUserAuthStore.getPreviews(p3):andThen(function(items)
						local v6 = nil

						for k, item in items do
							if item.asset == p5 then
								v6 = k
								break
							end
						end

						if v6 == nil then
							return Promise.reject(`Preview "{p5}" not found`)
						end

						local clone = table.clone(items)
						local clone2 = table.clone(items[v6])
						clone2.asset = `assets/{p6}`
						clone[v6] = clone2
						return assetUserAuthStore.updatePreviews(p3, clone)
					end)
				end)
			end, "replacePreview")
		end, { v5 }),
		removePreview = React.useCallback(function(p3, p4)
			return v5(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return assetUserAuthStore.getPreviews(p3):andThen(function(items)
					local v6 = nil

					for k, item in items do
						if item.asset == p4 then
							v6 = k
							break
						end
					end

					if v6 == nil then
						return Promise.reject(`Preview "{p4}" not found`)
					end

					local clone = table.clone(items)
					table.remove(clone, v6)
					return assetUserAuthStore.updatePreviews(p3, clone)
				end)
			end, "removePreview")
		end, { v5 })
	}
end

return useMediaUpdater
