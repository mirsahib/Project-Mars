function KNN()
  split=0.67;%split ratio
  data = csvread('iris_numerical.csv');
  data = data(2:151,2:6);
  [training_set,test]=loadDataSet(split,data);
  k=3;
  string0 = ['No of training Data: ',num2str(length(training_set)),' No of test Data: ',num2str(length(test)),' No of neighbour: ',num2str(k)];
  disp(string0);
  label = ['Setosa';'Versicolor';'Virginica'];
  prediction = zeros(1,length(test));
  for i = 1:length(test)
    neighbour = getNeighbour(training_set,test(i,1:4),k);
    result = getResponse(neighbour);
    prediction(i) = result;
    actual = test(i,5);
    string1 = ['predicted_value ',label(result,:),' actual_value ',label(actual,:)];
    #disp(string1);
  end
  accuracy = getAccuracy(prediction,test);
  string2 = ['Accuracy of the Classifier ',num2str(accuracy),'%'];
  disp(string2);
  #accuracy
end
function [x,y] =loadDataSet(split,data)
    x = [];
    y = [];
    for i = 1:150
      dataset = data(i,:);
      if rand()<split
        x = [x;dataset];
      else
        y = [y;dataset];
      end
    end
end
function [neighbour] = getNeighbour(training_set,instance,k)
  distance = zeros(length(training_set),6);
  neighbour = zeros(k,5);
  for i = 1:length(training_set)
    dist = norm(training_set(i,1:4)-instance);
    distance(i,:) = [training_set(i,:),dist];
  end
  distance = sortrows(distance,6);
  for i =1:k
    neighbour(i,:) = distance(i,1:5);
  end
end
function [vote] = getResponse(neighbour)
  class = zeros(1,3);
  [row,col] = size(neighbour);
  for i = 1:row
    index = neighbour(i,5);
    class(index) = class(index)+1;
  end
  max_value = max(class);
  vote = find(class==max_value);
end
function [accuracy] = getAccuracy(prediction,test)
  true_value = 0;
  for i = 1:length(test)
    if prediction(i)== test(i,5)
      true_value = true_value+1;
    end
  end
  accuracy = (true_value/length(test))*100;
end  