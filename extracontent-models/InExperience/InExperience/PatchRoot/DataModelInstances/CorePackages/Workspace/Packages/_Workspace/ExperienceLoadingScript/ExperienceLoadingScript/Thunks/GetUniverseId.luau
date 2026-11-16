local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local parent = ExperienceLoadingScript.Parent
local SetUniverseId = require(ExperienceLoadingScript.Actions.SetUniverseId)
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p)
	local function fn(object)
		local placeId = game.PlaceId
		local gameId = game.GameId

		while placeId <= 0 or gameId <= 0 do
			wait()
			placeId = game.PlaceId
			gameId = game.GameId
		end

		object:dispatch(SetUniverseId({ universeId = gameId, placeId = placeId }))
	end

	return function(object)
		coroutine.wrap(function()
			local placeId = p
			local universeId = game.GameId

			if placeId > 0 and universeId <= 0 then
				callback(string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, placeId), "GET"):andThen(
					function(p2)
						if p2 and p2.responseBody then
							universeId = p2.responseBody.universeId

							if universeId and universeId >= 0 then
								object:dispatch(SetUniverseId({
									universeId = universeId,
									placeId = placeId
								}))

								return
							end
						end

						fn(object)
					end,
					function(_)
						fn(object)
					end
				)
			else
				fn(object)
			end
		end)()
	end
end
