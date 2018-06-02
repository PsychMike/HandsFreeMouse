preview(vid);
% start(vid); 
%camlight('headlight') 
im1= getdata(vid,1);
im=rgb2gray(im1);
%im=imadjust(imgray,[],[
%STEP 2: K MEANS CLUSTERING%
k=10;
%histogram calculation
img_hist = zeros(256,1);
hist_value = zeros(256,1);
for i=1:256
	img_hist(i)=sum(sum(im==(i-1)));
end;
for i=1:256
	hist_value(i)=i-1;
end;
%cluster initialization
cluster = zeros(k,1);
cluster_count = zeros(k,1);
for i=1:k
	cluster(i)=uint8(rand*255);
end;
old = zeros(k,1);
while (sum(sum(abs(old-cluster))) >k)
	old = cluster;
	closest_cluster = zeros(256,1);
	min_distance = uint8(zeros(256,1));
	min_distance = abs(hist_value-cluster(1));
	%calculate the minimum distance to a cluster
	for i=2:k
		min_distance =min(min_distance,  abs(hist_value-cluster(i)));
	end;
	%calculate the closest cluster
	for i=1:k
		closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
	end;
	%calculate the cluster count
	for i=1:k
		cluster_count(i) = sum(img_hist .*(closest_cluster==i));
	end;
	for i=1:k
		if (cluster_count(i) == 0)
			cluster(i) = uint8(rand*255);
		else
			cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
        end;
	end;
	
end;
imresult=uint8(zeros(size(im)));
for i=1:256
	imresult(im==(i-1))=cluster(closest_cluster(i));
end;

clustersresult=uint8(zeros(size(im)));
for i=1:256
	clustersresult(im==(i-1))=closest_cluster(i);
end;
clusters = cluster;
result_image = imresult;
clusterized_image = clustersresult;
figure, imshow(result_image);
imtool(result_image);
%STEP 2 COMPLETE!%
%STEP 3: THRESHOLDING%
[m n]=size(result_image);
row1=round(m/3);
col1=round(n/3);
row2= 2*row1;
col2=col1*2;
min=30;
for i=row1:row2
    for j=col1:col2
        if(result_image(i,j)<min)
            min=result_image(i,j);
        end
    end
end
display(min);
for i=1:m
    for j=1:n
          if(result_image(i,j)<60)
            result_image(i,j)=0;
         end
          if( result_image(i,j)>60)
              result_image(i,j)=255;
          end
      end
  end
%figure, imshow(result_image);
%STEP 3 COMPLETE!%
%FILLING HOLES%
[x y]=size(result_image);
row1=round(x/3);
col1=round(y/3);
row2= 2*row1;
col2=col1*2;
cntwhite=0; cntblk=0;
for i=1:row1
    for j=1:y
        if(result_image(i,j)==255)
            result_image(i,j)=0;
        end
    end
end
for i=row2:x
    for j=1:y
        if(result_image(i,j)==255)
            result_image(i,j)=0;
        end
    end
end
for i=1:x
    for j=1:col1
        if(result_image(i,j)==255)
            result_image(i,j)=0;
        end
    end
end
for i=1:x
    for j=col2:y
        if(result_image(i,j)==255)
            result_image(i,j)=0;
        end
    end
end
for i=row1:row2
    for j=col1:col2
        if(result_image(i,j)==255)
            cntwhite=cntwhite+1;
        else
            cntblk=cntblk+1;
        end
    end
end
imtool(result_image);
%filling holes done%
display(cntwhite);
display(cntblk);
%connected component labelling + filtering%
[L, n]= bwlabel(result_image, 4);
filter= [0,0,0,0,0; 0,0,255,0,0; 0,255,255,255,0; 0,0,255,0,0; 0,0,0,0,0];
%dbstop if error
flag=0;
for k=1:n
    [r, c]=find(L==k);
    if(flag==1)
        break;
    end
    for i=(r-6):r
    for j=10:(y-10)
        counter=0;
        if(flag==1)
        break;
        end
          if(i==x || j==y || i==(x-1) || j==(y-1) || i<=0 || (i-1)<=0 || (i-2)<=0 || i<row1 || j<col1 || j>col2 || i>row2)
              continue
          end
          
                        if(result_image(i-2,j-2)==filter(1,1))
              counter=counter+1;
              end
              if(result_image(i-2,j-1)==filter(1,2))
              counter=counter+1;
              end
              if(result_image(i-2,j)==filter(1,3))
              counter=counter+1;
              end
              if(result_image(i-2,j+1)==filter(1,4))
              counter=counter+1;
              end
              if(result_image(i-2,j+2)==filter(1,5))
              counter=counter+1;
              end
              if(result_image(i-1,j-2)==filter(2,1))
              counter=counter+1;
              end
              if(result_image(i-1,j-1)==filter(2,2))
              counter=counter+1;
              end
              if(result_image(i-1,j)==filter(2,3))
              counter=counter+1;
              end
              if(result_image(i-1,j+1)==filter(2,4))
              counter=counter+1;
              end
              if(result_image(i-1,j+2)==filter(2,5))
              counter=counter+1;
              end
              if(result_image(i,j-2)==filter(3,1))
              counter=counter+1;
              end
              if(result_image(i,j-1)==filter(3,2))
              counter=counter+1;
              end
              if(result_image(i,j)==filter(3,3))
              counter=counter+1;
              end
              if(result_image(i,j+1)==filter(3,4))
              counter=counter+1;
              end
              if(result_image(i,j+2)==filter(3,5))
              counter=counter+1;
              end
              if(result_image(i+1,j-2)==filter(4,1))
              counter=counter+1;
              end
              if(result_image(i+1,j-1)==filter(4,2))
              counter=counter+1;
              end
              if(result_image(i+1,j)==filter(4,3))
              counter=counter+1;
              end
              if(result_image(i+1,j+1)==filter(4,4))
              counter=counter+1;
              end
              if(result_image(i+1,j+2)==filter(4,5))
              counter=counter+1;
              end
              if(result_image(i+2,j-2)==filter(5,1))
              counter=counter+1;
              end
              if(result_image(i+2,j-1)==filter(5,2))
              counter=counter+1;
              end
              if(result_image(i+2,j)==filter(5,3))
              counter=counter+1;
              end
              if(result_image(i+2,j+1)==filter(5,4))
              counter=counter+1;
              end
              if(result_image(i+2,j+2)==filter(5,5))
              counter=counter+1;
              end
              if(counter>21)
                  %display('found match');
                  if(j<(round(y/2)))
                      xcoor=j+25;
                  end
                  if(j>(round(y/2)))
                      xcoor=j-25;
                  end
                  ycoor=i;
                  display(xcoor);
                  display(ycoor);
                  flag=1;
                  break;
                  %end
              end
      end
      end
end
if(flag==0)
    display('error!');
end