function k_mean(n)
  load mnist_train;
  point = digits(:,1:10000);
  distance_vector = ones(1,n);% because we have n no. of cluster than we will have n no of datapoint
  [centroid_vector,var] = assign_centroid(n,point);%assigning random centroid
  centroid_diff = ones(1,n);
  while norm(centroid_diff)>10.^-5%convergence loop
    cluster = zeros(10000,n);% 10000 represent no.of datapoint and n represent no. of cluster
    for i=1:10000%10000 datapoint 
      for j = 1:n
        distance_vector(j) = norm(centroid_vector(:,j)-point(:,i)); %distance between centroid to datapoint
      end
      min_distance = min(distance_vector);%find min distance fromt the distance vector
      min_index = find(distance_vector==min_distance); % find the index of the minimum distance
      cluster = map_cluster(cluster,min_index,i);% datapoint is map according to the centroid
      %(i.e if x1 has minimum distance from centroid 1 then the 1st row & 1st col of centroid 1 will be 1)
    end%1st for loop end
    %x = check_cluster(cluster,n);
    new_centroid_vector = cluster_avg(cluster,point,n);%assigning new centroid
    centroid_diff = new_centroid_vector-centroid_vector;%calculating difference between each centroid
    %norm(centroid_diff) %ignore this 
    centroid_vector = new_centroid_vector; % assigning new centroid as current centroid
  end  %while end
  plot_k_mean(centroid_vector); 
end

function [vector,cluster_var] = assign_centroid(n,point)
  cluster_var = [];
  vector = zeros(784,n);% each centroid is 784 dimensional
  for i = 1:n % this loop will run the number of cluster we have i.e k time
    x = randi(10000,1,1);%generating a random integer
    cluster_var = [cluster_var,x];%for debugging
    vector(:,i) = point(:,x);% choosing a random column as ith centroid
  end
end
function [vector] = map_cluster(cluster,min_index,point_index)
  for i=1:10000
    if cluster(i,min_index)==0
      cluster(i,min_index) = point_index;      
      break
    end
  end
  vector = cluster;
end
%no need for this function
function [x] = check_cluster(cluster,n)
  x = 0;
  for i=1:3
    for j = 1:10000
      if (cluster(j,i)~=0)
        x=x+1;
      end
    end
  end
end
function [vector] = cluster_avg(cluster,point,n)
  vector = zeros(784,n);
  for i=1:n
    sum = [];
    for j = 1:10000
      if (cluster(j,i)~=0)
        datapoint = cluster(j,i);%storing the index of datapoint
        %point(:,datapoint) collect the datapoint column ignore this
        sum=[sum,point(:,datapoint)];%inserting each datapoint into a vector
      end
    end
    %sum
    %x = mean(sum,2);
    vector(:,i) = mean(sum,2);%assign the mean to each cluster
  end  
  %vector = cluster;
end
function plot_k_mean(vector)
    for k = 1:20
        subplot(4,5,k)
        imshow(reshape(vector(:,k),28,28))
    end
end

