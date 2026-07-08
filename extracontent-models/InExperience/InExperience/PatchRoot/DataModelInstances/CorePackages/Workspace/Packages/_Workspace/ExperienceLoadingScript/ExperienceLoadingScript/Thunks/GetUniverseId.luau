local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local SetUniverseId = require(ExperienceLoadingScript.Actions.SetUniverseId)
local Url = require(ExperienceLoadingScriptParent.Http).Url

return function(p1, p2) -- line: 6
	-- upvalues: SetUniverseId (copy), Url (copy)
	local function v7(p3) -- line: 7
		-- upvalues: SetUniverseId (copy)
		local PlaceId = game.PlaceId
		local GameId = game.GameId

		while PlaceId <= 0 or GameId <= 0 do
			wait()
			PlaceId = game.PlaceId
			GameId = game.GameId
		end

		p3:dispatch(SetUniverseId({
			universeId = GameId,
			placeId = PlaceId
		}))
	end

	return function(p4) -- line: 23
		-- upvalues: p2 (copy), Url (copy), p1 (copy), SetUniverseId (copy), v7 (copy)
		coroutine.wrap(function() -- line: 24
			-- upvalues: p2 (copy), Url (copy), p1 (copy), p4 (copy), SetUniverseId (copy), v7 (copy)
			local v12 = p2
			local GameId = game.GameId

			if v12 > 0 and GameId <= 0 then
				local v14 = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, v12)

				p1(v14, "GET"):andThen(function(p5) -- line: 31
					-- upvalues: GameId (ref), p4 (copy), SetUniverseId (copy), v12 (copy), v7 (copy)
					if p5 and p5.responseBody then
						GameId = p5.responseBody.universeId

						if GameId and GameId >= 0 then
							p4:dispatch(SetUniverseId({
								universeId = GameId,
								placeId = v12
							}))

							return
						end
					end

					v7(p4)
				end, function(_) -- line: 44
					-- upvalues: v7 (copy), p4 (copy)
					v7(p4)
				end)
			else
				v7(p4)
			end
		end)()
	end
end
