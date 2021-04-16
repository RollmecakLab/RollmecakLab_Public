%% First load the data then ... 
clear CatAge;
clear CatEvents;
clear CatFreq;
clear CatLengths;
clear CatTimes;
clear GrowthTimes;
clear LagTimes;
clear Lag Events;
clear GrowthRates
clear PercentTime;
clear ResFreq;
clear NumCat;
clear RescRat;
clear CatRates;
clear AverageGR;
clear GL_MT;

NumberOfTubes=max(CurrentChamber(:,4)) % gets the number of tubes..now look at each one...
SlowGrowers=find((CurrentChamber(:,1)<0.05 & CurrentChamber(:,1)>0 ));
CurrentChamber(SlowGrowers,1)=0;
SlowShrinkers=find((CurrentChamber(:,1)<0 & CurrentChamber(:,1)>-0.5 ));
CurrentChamber(SlowShrinkers,1)=0;

CatFreq(1,2)=-6000000

CatLengths(1,2)=-1000;
GrowthRates(1,2)=-11111;
ResFreq(1,2)=-111111;
NumResc(1,2)=-111111;
RescRat(1,2)=-11111;
NumCat(1,2)=-11111;
CatAge(1,2)=-60000;
LagTime(1,2)=-60000;
CatRates(1,2)=-22222;

for(i=1:NumberOfTubes)
    currentTubeRows=find(CurrentChamber(:,4)==i); % gets the current tube rows
    currentTubeData = CurrentChamber(currentTubeRows(1):currentTubeRows(end), 1:5); %gets the data on the current tube
        % First get the TIME of Grow/Cat/and Lag
      GrowthTimes=0;
      CatTimes=0;
      LagTimes=0;
      NoGrowtimes=0;
      GL_MT=0;
      % AverageGR=0;?
      
       i;
      GrowthTimes=GrowthTimes + sum ( currentTubeData(find(currentTubeData(:,1)>0),3));% gets the total growth TIME
      CatTimes   =CatTimes + sum ( currentTubeData(find(currentTubeData(:,1)<0),3)); % gets the total cat TIME
      NoGrowths = find(currentTubeData(:,2)==0); % - gets the periods of no growth.. 
      GL_MT = GL_MT + sum ( currentTubeData(find(currentTubeData(:,1)>0),2));
      AverageGR(i,1) = i;
      AverageGR(i,2) = GL_MT/GrowthTimes;
      
      for ( k=1:numel(NoGrowths))
          if ( NoGrowths(k)==1 || NoGrowths(k)==numel(currentTubeData(:,1)) ) % if it starts or ends with a no growth ignore it
         % NoGrowtimes=NoGrowtimes+currentTubeData(k,1)
          else 
              LagTimes=LagTimes+currentTubeData(NoGrowths(k),3); % otherwise add it...
              LagTime(end+1,2)=currentTubeData(NoGrowths(k),3);
              %LagPositions(:,1)=NoGrowths(k);
          end
      end % end the lag check loop
 
      %CatFreq(1,2)=-6000000;
      
      % - now count # of Cat. and get cat Freq.
      NumberOfCat=numel(find(currentTubeData(:,1)<0)); % that was easy enough
      CatFreq(i,1)=i;
      CatFreq(i,2) = NumberOfCat/GrowthTimes    % number of cat / time spent growing % Good up to here
      
      %CatRate(i,1)=currentTubeData(find(currentTubeData(:,1)<0),1);
      %CatRate(i,2)=abs(CatRate(i,1));
      
      %CatLengths(1,2)=-12345;
      CatEvents = find(currentTubeData(:,1)<0);
      % - now get the Length at cat...
    
      for ( N=1:numel(CatEvents))
          CatLengths(end+1,2)=abs(currentTubeData(CatEvents(N),2));
      end   
      
      % - now check for Age At Cat...and back calculate as neccessary
      %CatAge(1,2)=-12345;C
        for ( N=1:numel(CatEvents))
            
            CatRates(end+1,2)=abs(currentTubeData(CatEvents(N),1));
            
            if( abs(currentTubeData(CatEvents(N),2)) >  currentTubeData(CatEvents(N)-1,2))
%                % if it is bigger back calculate the age...
                CatAge(end+1,2)=abs(currentTubeData(CatEvents(N),2))/currentTubeData(CatEvents(N)-1,1);
            else
                CatAge(end+1,2)=currentTubeData(CatEvents(N)-1,3);
            end
        end
        % - get the (+) growth Rates
        
        
        %GrowthRates(1,2)=-11111;
        GrowthEvents=find(currentTubeData(:,1)>0);
        for(N=1:numel(GrowthEvents))
            GrowthRates(end+1,2)=currentTubeData(GrowthEvents(N),1);
        end
      % - what next?  GOtta Check For Rescues..these should be rare events
      % but if the cat length is SHORTER than the previous growth, it is a
      % rescue (unless it ends during a cat, which I don't think ever
      % happens...so..
      %i
      NumRescueEvents=0;
     % ResFreq(1,2)=-111111;
 %%
     for ( N=1:numel(CatEvents)) % - for each cat event.....
          if( currentTubeData(CatEvents(N)+1,1)>0 && currentTubeData(CatEvents(N)-1,1)>0)   % - only when there is growth before and after
              if(abs(currentTubeData(CatEvents(N),2)) <currentTubeData(CatEvents(N)-1,2)-.2 )     %( abs((currentTubeData(CatEvents(N),2)) < abs((currentTubeData(CatEvents(N)+1,2))+0.2)) ||abs(( currentTubeData(CatEvents(N),2)) < abs((currentTubeData(CatEvents(N)-1,2))+0.2)))
                 NumRescueEvents=NumRescueEvents+1;
             elseif ( currentTubeData(CatEvents(N),5) >2) % - this is where we need to back calc to see if it is a rescue
                 NumRescueEvents=NumRescueEvents+1;
              end
          end
      end
      ResFreq(i,2)=NumRescueEvents/CatTimes;
  %-next two lines added april 2016
      NumResc(i,2)=NumRescueEvents; 
      RescRat(i,2)=NumRescueEvents./(numel(CatEvents));
      NumCat(i,2)=numel(CatEvents);
%%
      %       % - working up to here now to get the % of times doing shit...
%       PercentTime(i,1)= 100*(GrowthTimes+CatTimes+LagTimes+/30); % - the do nothing times...
%       PercentTime(i,2)=100*(CatTimes/30);
%       PercentTime(i,3)=100*(LagTimes/30);
%       PercentTime(i,4)=100-(PercentTime(i,1)+PercentTime(i,2)+ PercentTime(i,3));
      
      
      
      
      PercentTime(i,1)= 100*(GrowthTimes/30);
      PercentTime(i,2)=100*(CatTimes/30);
      PercentTime(i,3)=100*(LagTimes/30);
      PercentTime(i,4)=100-(PercentTime(i,1)+PercentTime(i,2)+ PercentTime(i,3));
      
      
      %_ Working Perfectly..now get stuff in the 'correct' units...
      
    
     
end
 %GrowthRates=GrowthRates.*(1000/60);% to get form um/min to nm/sec
 %CatAge=CatAge.*60; % to get s
 %CatFreq=CatFreq./60; % to get inverse s
 
      
      
      
      




