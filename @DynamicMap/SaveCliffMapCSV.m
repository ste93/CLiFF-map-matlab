function [ ] = SaveCliffMapCSV(obj,filename)

AllMeans=vertcat(obj.Batches(:).Mean);
try
    MaxSpeed=max(AllMeans(:,2));
catch ME
    % Handle exception
    disp(['No cliff learned here, too few data']);
    return;  % Exit the function immediately
end

RES=[];
for i=1:numel(obj.Batches)
   if ~isempty(obj.Batches(i).Mean)
       [U,V]=pol2cart(obj.Batches(i).Mean(:,1),obj.Batches(i).Mean(:,2));
       
       r=length(U);
       batch_num=repmat(i,r,1);
       C=repmat(obj.Batches(i).Pose,r,1);
       motion_ratio_p=repmat(obj.Batches(i).p,r,1);
       observation_ratio_q=repmat(obj.Batches(i).q,r,1);
       cov_1=reshape(obj.Batches(i).Cov(1,1,:),[r,1]);
       cov_2=reshape(obj.Batches(i).Cov(1,2,:),[r,1]);
       cov_3=reshape(obj.Batches(i).Cov(2,1,:),[r,1]);
       cov_4=reshape(obj.Batches(i).Cov(2,2,:),[r,1]);

       % RES=[RES;C(:,1) C(:,2) obj.Batches(i).Mean(:,1) obj.Batches(i).Mean(:,2) obj.Batches(i).Cov(1,1,:) obj.Batches(i).Cov(1,2,:) obj.Batches(i).Cov(2,1,:) obj.Batches(i).Cov(2,2,:) obj.Batches(i).P obj.Batches(i).p obj.Batches(i).q];
       RES=[RES;C(:,1) C(:,2) obj.Batches(i).Mean(:,1) obj.Batches(i).Mean(:,2) cov_1 cov_2 cov_3 cov_4 obj.Batches(i).P motion_ratio_p observation_ratio_q];
       
   end
end

csvwrite(filename,RES)
end
