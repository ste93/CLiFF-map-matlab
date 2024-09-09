clear all;
full_path=fullfile("./Data/atc-20121031_2.5_ds.csv");

DATA=csvread(full_path);
DM=DynamicMap();
% Load time stamps of measurements
DM.TimeStamp=DATA(:,2); 
% Load cooridantes of the measuremnts
DM.Position=DATA(:,3:4); 
% Load velocity measurements in Kartesian cooridnate frame
DM.UV=DATA(:,5:6); 
% Convert measurements to the polar cooridante frame
[TH,R]=cart2pol(DM.UV(:,1),DM.UV(:,2)); 
DM.ThetaRho=[TH,R]; 


min_x=min(DATA(:,3)/1000)-2;
max_x=max(DATA(:,3)/1000)+2;
min_y=min(DATA(:,4)/1000)-2;
max_y=max(DATA(:,4)/1000)+2;


DM.File=full_path;

DM=DM.SetParameters(1,min_x,max_x,min_y,max_y,1,1);
DM=DM.SplitToLocations();
DM=DM.ProcessBatches();

fprintf("Computing P and Q\n");
max_q = 0.0;
for i=1:numel(DM.Batches)
  DM.Batches(i).p = 1.0;
  DM.Batches(i).q = size(DM.Batches(i).Data,1);
  if(DM.Batches(i).q > max_q)
    max_q = DM.Batches(i).q;
  end
end

for i = 1:numel(DM.Batches)
  DM.Batches(i).q = DM.Batches(i).q / max_q;
end

DM.SaveCliffMapCSV("./Results/cliff_map_85_april.csv");
FILE='./Results/cliff_map_85_april.csv';

DM.File=FILE;
% % Plot the color-coded input data
DM.PlotUVDirection(2)
%Plot resulting distribution
DM.PlotMapDirection(0,1.5)

DM.SaveXML('Results/pedestrian_map.xml')
%for i = 1:numel(DM.Batches)
%  DM.Batches(i).q = DM.Batches(i).q / max_q;
%end

%for i = 1:numel(DM.Batches)
%  DM.Batches(i).q = DM.Batches(i).q / max_q;
%end

% DM.SaveCliffMapCSV("/home/yufei/research/constant-velocity-cliff/constant-velocity-cliff/cliff/atc/atc-cliff-1-hour-1028-v2/" + num2str(hour) + ".csv");
% DM.SaveCliffMapCSV("/home/yufei/research/constant-velocity-cliff/constant-velocity-cliff/cliff/atc-workshop-cliff-v4/b" + num2str(bn) + "/" + sample_name + ".csv");
  