function normalized = Normalize(array, x, y)

     % Normalize to [0, 1]:
     m = min(min(array));
     range = max(max(array)) - m;
     array = (array - m) / range;

     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (array*range2) + x;
     
end