local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Http = require(MomentsParent.Http)
local HttpClient = require(MomentsParent.HttpClient)
local GetFFlagMomentsFixDelete = require(Moments.Flags.GetFFlagMomentsFixDelete)
local v6 = Http.Url.APIS_URL .. "content-captures-api/v2/moments/"
local v7 = Http.Url.APIS_URL .. "/posts-api/v1/content-posts/delete/"

local function deleteMoment(s1: string, p1) -- line: 26
	-- upvalues: GetFFlagMomentsFixDelete (copy), HttpClient (copy), v7 (copy), v6 (copy)
	if not GetFFlagMomentsFixDelete() then
		return HttpClient.asPromise(HttpClient.fetch({
			method = "POST",
			analyticsKey = "moments.delete-moment",
			url = v7 .. s1,
			body = {},
			network = p1,
			decode = function(_) -- line: 35
				return {
					ok = true
				}
			end
		}))
	end

	return HttpClient.asPromise(HttpClient.fetch({
		method = "DELETE",
		analyticsKey = "moments.delete-moment",
		url = v6 .. s1,
		network = p1,
		decode = function(_) -- line: 46
			return {
				ok = true
			}
		end
	}))
end

return deleteMoment
