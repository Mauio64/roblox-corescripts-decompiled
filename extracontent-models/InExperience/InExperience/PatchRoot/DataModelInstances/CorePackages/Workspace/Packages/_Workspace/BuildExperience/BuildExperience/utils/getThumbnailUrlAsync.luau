local Parent = script:FindFirstAncestor("BuildExperience").Parent
local HttpClient = require(Parent.HttpClient)
local Promise = require(Parent.Promise)
local debug = require(Parent.DataHydration.CreatorAgentChat).debug
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function getThumbnailUrlAsync(n1: number, s1: string?) -- line: 26
	-- upvalues: debug (copy), Promise (copy), fetch (copy), asPromise (copy)
	local v10 = s1 or "420x420"

	debug.log("info", "thumbnail_url polling", {
		assetId = n1
	})

	return Promise.new(function(resolve, reject) -- line: 31
		-- upvalues: fetch (copy), n1 (copy), v10 (copy), asPromise (copy), debug (copy)
		local n2 = 0

		local function poll(n3: number) -- line: 34
			-- upvalues: fetch (copy), n1 (copy), v10 (copy), asPromise (copy), reject (copy), debug (copy), resolve (copy), n2 (ref), poll (copy)
			local v16 = fetch({
				method = "POST",
				url = "https://thumbnails.roblox.com/v1/batch",
				analyticsKey = "build-experience.get-thumbnail-url",
				body = {{
					type = "Asset",
					format = "Png",
					targetId = n1,
					size = v10
				}},
				decode = function(p1) -- line: 47
					return p1
				end
			})

			asPromise(v16):andThen(function(p2) -- line: 53
				-- upvalues: reject (copy), debug (copy), n1 (copy), resolve (copy), n2 (ref), poll (copy), n3 (copy)
				local v19 = p2 and p2.data

				if not v19 or #v19 == 0 then
					reject("No thumbnail data returned")

					return
				end

				local v20 = v19[1]

				if v20.state == "Completed" then
					debug.log("info", "thumbnail_url completed", {
						assetId = n1
					})
					resolve({
						status = "completed",
						imageUrl = v20.imageUrl
					})

					return
				end

				if v20.state == "InReview" then
					n2 += 1

					if n2 >= 5 then
						debug.log("warn", "thumbnail_url in_review timeout", {
							assetId = n1
						})
						resolve({
							status = "in_review",
							assetId = n1
						})

						return
					end

					task.delay(2, function() -- line: 70
						-- upvalues: poll (copy), n3 (copy)
						poll(n3 + 1)
					end)

					return
				end

				if v20.state == "Pending" then
					if n3 >= 15 then
						debug.log("warn", "thumbnail_url timed out", {
							assetId = n1
						})
						reject("Thumbnail generation timed out")

						return
					end

					task.delay(2, function() -- line: 79
						-- upvalues: poll (copy), n3 (copy)
						poll(n3 + 1)
					end)

					return
				end

				reject(`Thumbnail failed: { v20.state }`)
			end):catch(function(p3) -- line: 87
				-- upvalues: reject (copy)
				reject(p3)
			end)
		end

		poll(1)
	end)
end

return getThumbnailUrlAsync
