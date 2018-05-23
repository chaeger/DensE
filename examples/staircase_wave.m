clear
clc

addpath('../DensE/')

n = 1000;    % effective component code length
t = 3;       % erasure-correcting capability
W = 8;       % window size
maxIter = 7; % iterations per window
L = 30;      % number of spatial positions

scc = DE_staircase_code(t, L);
scheme = DE_scheme_detgpc(scc);
schedule = scc.get_window_decoding_schedule(maxIter, W, 0); 
scheme.set_schedule(schedule); % try commenting this line

gpc_sc = DE_base(DE_channel_gpc_bec, scheme, size(schedule, 1), 1e-10); 

c = 5.50;
gpc_sc.scheme.density_evolution(c);

fr = 3;
final_iter = 200;

make_gif = 0;
gif_filename = 'staircase.gif';

DEens = gpc_sc.scheme;
h = figure;
hold on
set(gcf, 'Position', [666 479 510 194]);
set(gcf, 'color', 'white');
frame_count = 1;
for i = 1:fr:final_iter
  title(['iteration = ' num2str(i)])
  p1 = plot(DEens.errProb(i, :), 'b*-');
  active = DEens.schedule{i,1};
  p2 = stem(active, 0.1*ones(size(active)), 'r');

  if(i == 1)
    ylim([0 1.5])
    xlim([1 L])
    xlabel('spatial position')
    ylabel('error probabilility per position')
    grid on
    box on
  end
  
  if(make_gif)
    drawnow
    f = getframe(h);
    if frame_count == 1
      [im_plot{frame_count},map] = rgb2ind(f.cdata,256,'nodither');
    else
      im_plot{frame_count} = rgb2ind(f.cdata,map,'nodither');
    end
  else
    pause(0.03)
  end
 
  if(i ~= final_iter)
    delete(p1)
    delete(p2)
  end
  
  frame_count = frame_count+1;
end
frame_count = frame_count-1;

if(make_gif)
  isize = size(im_plot{1});
  im = zeros(isize(1), isize(2), 1, length(im_plot)); 
  for i = 1:frame_count
    im(:,:,1,i) = im_plot{i};
  end
  imwrite(im, map, gif_filename,'gif', 'DelayTime', 0.08,'Loopcount',inf); 
end
