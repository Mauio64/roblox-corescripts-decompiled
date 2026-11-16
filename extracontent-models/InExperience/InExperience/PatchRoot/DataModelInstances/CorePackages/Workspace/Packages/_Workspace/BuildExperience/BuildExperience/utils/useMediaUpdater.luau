local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Promise = require(parent.Promise)

local AssetUserAuth = require(parent.DataHydration.AssetUserAuth)
local getAssetUserAuthStore = AssetUserAuth.getAssetUserAuthStore

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Debug = CreatorAgentChat.debug

local formatError = require(script.Parent.formatError)

local function useMediaUpdater(p)
	local ref = React.useRef(Promise.resolve())
	local onSuccess = p and p.onSuccess
	local onError = p and p.onError

	local v = React.useCallback(function(callback, p2: string)
		Debug.log("info", `media_updater {p2} enqueued`)
		local v = ref.current:catch(function(): nil
			return nil
		end):andThen(callback):andThen(function(p3)
			return getAssetUserAuthStore().pollUntilDone(p3)
		end):andThen(function(p3)
			if typeof(p3) == "table" and p3.status == "timed_out" then
				return Promise.reject("Operation did not complete in time")
			end

			return if p3.status == "done" then p3.operation else p3
		end)

		ref.current = v:catch(function(): nil
			return nil
		end)

		return v:andThen(function(p3)
			Debug.log("info", `media_updater {p2} succeeded`)

			if onSuccess then
				onSuccess()
			end

			return p3
		end):catch(function(p3)
			local err = formatError(p3)
			Debug.log("warn", `media_updater {p2} failed`, { error = err })

			if onError then
				onError(err)
			end

			return Promise.reject(p3)
		end)
	end, { onSuccess, onError })

	return {
		setIcon = React.useCallback(function(p2: string, p3)
			return v(function()
				return Promise.resolve(p3):andThen(function(p4: string)
					return getAssetUserAuthStore().updateIcon(p2, p4)
				end)
			end, "setIcon")
		end, { v }),
		addPreview = React.useCallback(function(p2: string, p3)
			return v(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return Promise.resolve(p3):andThen(function(p4: string)
					return assetUserAuthStore.getPreviews(p2):andThen(function(p5)
						local clone = table.clone(p5)
						table.insert(clone, { asset = `assets/{p4}` })
						return assetUserAuthStore.updatePreviews(p2, clone)
					end)
				end)
			end, "addPreview")
		end, { v }),
		replacePreview = React.useCallback(function(p2: string, p3, p4: string)
			return v(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return Promise.resolve(p3):andThen(function(p5: string)
					return assetUserAuthStore.getPreviews(p2):andThen(function(items)
						local v2 = nil

						for k, item in items do
							if item.asset == p4 then
								v2 = k
								break
							end
						end

						if v2 == nil then
							return Promise.reject(`Preview "{p4}" not found`)
						end

						local clone = table.clone(items)
						local clone2 = table.clone(items[v2])
						clone2.asset = `assets/{p5}`
						clone[v2] = clone2
						return assetUserAuthStore.updatePreviews(p2, clone)
					end)
				end)
			end, "replacePreview")
		end, { v }),
		removePreview = React.useCallback(function(p2: string, p3: string)
			return v(function()
				local assetUserAuthStore = getAssetUserAuthStore()
				return assetUserAuthStore.getPreviews(p2):andThen(function(items)
					local v2 = nil

					for k, item in items do
						if item.asset == p3 then
							v2 = k
							break
						end
					end

					if v2 == nil then
						return Promise.reject(`Preview "{p3}" not found`)
					end

					local clone = table.clone(items)
					table.remove(clone, v2)
					return assetUserAuthStore.updatePreviews(p2, clone)
				end)
			end, "removePreview")
		end, { v })
	}
end

return useMediaUpdater
