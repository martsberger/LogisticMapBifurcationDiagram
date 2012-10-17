function bif_diag = LogisticBifurcationDiagram2(M, N, r1, r2, x1, x2, quality)
% LogisticBifurcatioDiagram2(M, N, r1, r2, x1, x2, quality)
%
% Creates an image of the Logistic Map Bifurcation Diagram similar to
% the one on Wikipedia:
% http://upload.wikimedia.org/wikipedia/commons/5/50/Logistic_Bifurcation_map_High_Resolution.png
% Uses the current figure.
%
% All parameters are optional.
% The size of the figure is M+100 pixels high by N+100 pixels wide
% The horizontal axis range is from r1 to r2
% The vertical axis range is from x1 to x2
% quality controls how "smooth" the image looks. Higher quality comes
% from greater sampling at each r and takes longer to compute. If you want
% to play with the x and r limits to find a good range to plot, set the
% quality low for speed.
%
% Example of zooming in to see fractal:
% figure(1)
% LogisticBifurcationDiagram2(400, 700, 2.4, 4, 0, 1, 10);
% figure(2)
% LogisticBifurcationDiagram2(400, 700, 3.4, 3.63, 0.77, 0.91, 10);
% figure(3)
% LogisticBifurcationDiagram2(400, 700, 3.54, 3.58, 0.87, 0.895, 10);

% Set defaults
if nargin < 7
    quality = 10;
end
if nargin < 6
    x2 = 1;
    x1 = 0;
end
if nargin < 4
    r1 = 2.4;
    r2 = 3.999;
end
if nargin < 2
    N = 800;
    M = 500;
end

if quality < 1
    quality = 1
end

xlower = x1;
xupper = x2;

% r and x values where we make the image
r_vec = linspace(r1, r2, N);
x_vec = linspace(xlower-1/M,xupper+1/M,M+2);

% matrix of image pixels
bif_diag = zeros(M,N);

% length of non-transient dynamics
xxlen = quality*100;

h = waitbar(0, 'calculating image');
for k=2:N-1
    
    % For pixel at r, we calculated r values from r-dr/2 to r + dr/2
    r1 = 0.5*(r_vec(k) + r_vec(k-1));
    r2 = 0.5*(r_vec(k) + r_vec(k+1));
    dr = (r2-r1)/(quality);
    
    % x stores all the non-transient x values, computed using Cobweb2
    x = zeros(length(r1:dr:r2)*xxlen, 1);
    indx = 0;
    for r=r1:dr:r2
        xx = Cobweb2(r,.25, 1.05*xxlen + 1000, 1000 + 0.05*xxlen);
        %size(xx)
        x(indx*xxlen + 1:(indx+1)*xxlen) = xx;
        indx = indx + 1;
    end
    
    % Normalized histogram of how frequently we visit each pixel
    hx2 = hist(x,x_vec);
    hx2 = hx2(2:end-1);
    hx2 = hx2/max(hx2);
    
    bif_diag(:,k) = hx2;
    
    %if mod(k,round(N/50)) == 0
        %fprintf('.');
        h = waitbar(k/N, h, sprintf('calculating image: %2.0f %% done', 100*k/N));
    %end
    
end
h = waitbar(1, h, 'finished');
delete(h)
fprintf('\n')

clf
imagesc(bif_diag(end:-1:1,:))

set(gcf,'position',[30 30 N+100 M+100]);

xticks = linspace(r_vec(1),r_vec(end),9);
xticks = round(100*xticks)/100;
yticks = linspace(xlower,xupper,5);
yticks = round(100*yticks)/100;
xticklabels = strcat(num2str(xticks(1)),'|',num2str(xticks(2)),'|',num2str(xticks(3)),'|',num2str(xticks(4)),'|',num2str(xticks(5)),'|',num2str(xticks(6)),'|',num2str(xticks(7)),'|',num2str(xticks(8)),'|',num2str(xticks(9)));
yticklabels = strcat(num2str(yticks(5)),'|',num2str(yticks(4)),'|',num2str(yticks(3)),'|',num2str(yticks(2)),'|',num2str(yticks(1)));
set(gca,'position',[80/(N+100) 80/(M+100) N/(N+100) M/(M+100)],'xtick',linspace(0.5,N+.5,9),'ytick',linspace(0.5,M+.5,5),'xticklabel',xticklabels,'yticklabel',yticklabels,'fontsize',18,'fontname','times','linewidth',1.5,'tickdir','out')

caxis([0 0.7])

xlabel('r','fontsize',18,'fontname','times');
ylabel('x','fontsize',18,'fontname','times');

%cmap = gray;
cmap(1,:) = [1 1 1];
for j = 2:64
    v = ((64-j)/64)^3;
    cmap(j,:) = [v v v];
end
colormap(cmap)