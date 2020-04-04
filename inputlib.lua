-- input library

--[[
copyright 2020 jbq

licensed under the apache license, version 2.0 (the "license");
you may not use this file except in compliance with the license.
you may obtain a copy of the license at

    http://www.apache.org/licenses/license-2.0

unless required by applicable law or agreed to in writing, software
distributed under the license is distributed on an "as is" basis,
without warranties or conditions of any kind, either express or implied.
see the license for the specific language governing permissions and
limitations under the license.
]]

input={}
function input:init()
	self.wait=true
	self.bstate={}
	self.transition={}
	self.semantic={}
	self.lastchange={}
end
function input:update()
	if (self.wait) then
		self.wait = btn()!=0
	else
		local i,t
		t=time()
		for i = 1,6 do
			local b=btn(i-1)
			if b and not self.bstate[i] then
				self.transition[i]=1
			elseif self.bstate[i] and not b then
				self.transition[i]=-1
			else
				self.transition[i]=0
			end
			self.bstate[i]=b
			if self.transition[i] != 0 then
				self.lastchange[i]=t
			end
		end
	end
end
function input:state(n)
	return self.bstate[n]
end
function input:pressednow(n)
	return self.transition[n] == 1
end
function input:releasednow(n)
	return self.transition[n] == -1
end
