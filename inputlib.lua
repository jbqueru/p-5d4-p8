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
function input:allbuttons()
	return btn()
end
function input:button(i)
	return btn(i)
end
function input:time()
	return time()
end
function input:init()
	self.wait=true
	self.timerdelay=0.15
	self.bstate={}
	self.transition={0,0,0,0,0,0}
	self.sequence={0,0,0,0,0,0}
	self.timerstart={0,0,0,0,0,0}
	self.semantic={0,0,0,0,0,0}
end
function input:update()
	if (self.wait) then
		self.wait = self:allbuttons()!=0
	else
		local i,t
		t=self:time()+0.008
		for i = 1,6 do
			local b=self:button(i-1)
			if b and not self.bstate[i] then
				self.transition[i]=1
			elseif self.bstate[i] and not b then
				self.transition[i]=-1
			else
				self.transition[i]=0
			end
			self.bstate[i]=b

--[[
	idle: s=0, t=0. transition: pressed -> recentpressed, s=-1, start timer
	recentpressed: s<0. transition: released -> recentreleased, -s, start timer
		transition: timer -> idle, report s, s=0, start 2x timer
	recentreleased: s>0. transition: pressed -> recentpressed, -s-1, start timer
		transition: timer -> idle, report s, s=0. t=0
	longpress: s=0, t!=0. transition: released -> idle, t=0
		transition: timer -> longpress, report repeat, start timer
]]
			self.semantic[i]=0
			if self.sequence[i]==0 and self.timerstart[i]==0 then -- idle
				if self.transition[i]==1 then -- pressed
					self.sequence[i]=-1
					self.timerstart[i]=t
				end
			elseif self.sequence[i]<0 then -- recentpressed
				if self.transition[i]==-1 then -- released
					self.sequence[i]=-self.sequence[i]
					self.timerstart[i]=t
				elseif t-self.timerstart[i]>=self.timerdelay then -- timer expired
					self.semantic[i]=self.sequence[i]
					self.sequence[i]=0
					self.timerstart[i]=t+self.timerdelay -- make the first repeat take 3x normal
				end
			elseif self.sequence[i]>0 then -- recentreleased
				if self.transition[i]==1 then -- pressed
					self.sequence[i]=-self.sequence[i]-1
					self.timerstart[i]=t
				elseif t-self.timerstart[i]>=self.timerdelay then -- timer expired
					self.semantic[i]=self.sequence[i]
					self.sequence[i]=0
					self.timerstart[i]=0
				end
			elseif self.sequence[i]==0 and self.timerstart[i]!=0 then -- repeating
				if self.transition[i]==-1 then -- released
					self.timerstart[i]=0
				elseif t-self.timerstart[i]>=self.timerdelay then -- timer expired
					self.transition[i]=2
					self.timerstart[i]=t
				end
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
function input:actionnow(n)
	return self.transition[n]>0
end
function input:multinow(n)
	return self.semantic[n]
end
