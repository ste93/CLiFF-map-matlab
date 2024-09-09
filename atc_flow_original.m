clear all;
full_path=fullfile("./Data/atc-20121031_2.5_ds.csv");

DATA=csvread(full_path);
DM=DynamicMap();
DM.TimeStamp=DATA(:,1); 
DM.Position=DATA(:,3:4)/1000; 

DM.ThetaRho=[DATA(:,7),DATA(:,6)/1000]; 
[U,V]=pol2cart(DATA(:,7),DATA(:,6)/1000);
DM.UV=[U,V];

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

%for i = 1:numel(DM.Batches)
%  DM.Batches(i).q = DM.Batches(i).q / max_q;
%end
FILE='atc-20121024_2.5_ds.csv';
DM.File=FILE;
% % Plot the color-coded input data
DM.PlotUVDirection(2)
%Plot resulting distribution
DM.PlotMapDirection(0,1.5)

% DM.SaveCliffMapCSV("/home/yufei/research/constant-velocity-cliff/constant-velocity-cliff/cliff/atc/atc-cliff-1-hour-1028-v2/" + num2str(hour) + ".csv");
M.SaveCliffMapCSV("./Results/atc_flow_opriginal.csv");
% DM.SaveCliffMapCSV("/home/yufei/research/constant-velocity-cliff/constant-velocity-cliff/cliff/atc-workshop-cliff-v4/b" + num2str(bn) + "/" + sample_name + ".csv");