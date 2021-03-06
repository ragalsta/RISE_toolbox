function [plot_handle,axis_handle]=plot(this,varargin)
datta=double(this);
if size(datta,2)>1 && size(datta,3)>1
    error([mfilename,':: cannot handle many variables and many pages simultaneously'])
else
    datta=squeeze(datta);
end

level=3;

switch level
    case 1
        first_date=this.TimeInfo(1).date;
        last_date=this.TimeInfo(end).date;
        switch this.frequency
            case ''
                year_start=str2double(first_date);
                year_end=str2double(last_date);
                period_start=1;
                period_end=1;
                increment=1;
            case 'H'
                loc=strfind(first_date,'H');
                year_start=str2double(first_date(1:loc-1));
                period_start=str2double(first_date(loc+1:end));
                loc=strfind(last_date,'H');
                year_end=str2double(last_date(1:loc-1));
                period_end=str2double(last_date(loc+1:end));
                increment=1/2;
            case 'Q'
                loc=strfind(first_date,'Q');
                year_start=str2double(first_date(1:loc-1));
                period_start=str2double(first_date(loc+1:end));
                loc=strfind(last_date,'Q');
                year_end=str2double(last_date(1:loc-1));
                period_end=str2double(last_date(loc+1:end));
                increment=1/4;
            case 'M'
                loc=strfind(first_date,'M');
                year_start=str2double(first_date(1:loc-1));
                period_start=str2double(first_date(loc+1:end));
                loc=strfind(last_date,'M');
                year_end=str2double(last_date(1:loc-1));
                period_end=str2double(last_date(loc+1:end));
                increment=1/12;
            case {'W','D'}
                error([mfilename,':: weekly and daily plots not yet implemented for this level'])
        end
        xaxis=year_start+(period_start-1)*increment:increment:year_end+(period_end-1)*increment;
        digit=4;
        xaxis=round(xaxis.*(10^digit))./(10^digit);
        tmp=plot(xaxis(:),datta,varargin{:});
    case 2
        date_numbers=vertcat(this.TimeInfo.date_number);
        tmp=plot(date_numbers,datta,varargin{:});
        switch this.frequency
            case ''
                datetick('x','yyyy');
            case {'H','Q'}
                datetick('x','QQ-YY');
            case {'M','W','D'}
                datetick('x','mmmyy');
        end
    case 3
        date_numbers=vertcat(this.TimeInfo.date_number);
        tmp=plot(date_numbers,datta,varargin{:});
        NumTicks = min(5,numel(date_numbers));
        tick_locs=round(linspace(1,100,NumTicks)/100*numel(date_numbers));
        tick_locs(tick_locs==0)=1;
        tick_locs=date_numbers(tick_locs);
        switch this.frequency
            case ''
                date_format='yy';
            case {'H','Q'}
                date_format='QQ-YY';
            case {'M','W','D'}
                date_format='mmmyy';
        end

        tick_labels=datestr(tick_locs,date_format);
        set(gca,'XLim',[date_numbers(1),date_numbers(end)],...
            'XTick',tick_locs,...
            'XTickLabel',tick_labels)
%       10             'yyyy'                   2000         
%       11             'yy'                     00           
%       12             'mmmyy'                  Mar00        
%       17             'QQ-YY'                  Q1-96        
%       28             'mmmyyyy'                Mar2000        
end
grid on

if nargout>0
    plot_handle=tmp;
    if nargout>1
        axis_handle=get(gca);
    end
end
end
function [plot_handle]=line(this,varargin)
date_numbers=vertcat(this.TimeInfo.date_number);
datta=double(this);
if size(datta,3)>1
    error([mfilename,':: this operation is only defined for databases with one page'])
end
NumTicks = 8;
tick_locs=round(linspace(1,100,NumTicks)/100*numel(date_numbers));
tick_locs(tick_locs==0)=1;
tick_locs=date_numbers(tick_locs);
tick_labels=datestr(tick_locs,11);
if this.NumberOfVariables==2
    line(date_numbers,datta(:,1),'Color','r');
    ax1 = gca;
    %                 set(ax1,'XColor','r','YColor','r')
    ax2 = axes('Position',get(ax1,'Position'),...
        'YAxisLocation','right',...
        'Color','none');
    %                     'XAxisLocation','top',...
    %                     'XColor','k','YColor','k'
    line(date_numbers,datta(:,2),'Color','k','Parent',ax2);
    set([ax1,ax2],'XLim',[date_numbers(1),date_numbers(end)],...
        'XTick',tick_locs,...
        'XTickLabel',tick_labels)
else
    line(date_numbers,datta,varargin{:});
    set(gca,'XLim',[date_numbers(1),date_numbers(end)],...
        'XTick',tick_locs,...
        'XTickLabel',tick_labels)
end
if nargout>0
    plot_handle=gca;
end
end
function H=bar(this,varargin)
date_numbers=vertcat(this.TimeInfo.date_number);
datta=double(this);
if size(datta,3)>1
    error([mfilename,':: this operation is only defined for databases with one page'])
end
tmp=bar(date_numbers,datta,varargin{:});
NumTicks = 8;
tick_locs=round(linspace(1,100,NumTicks)/100*numel(date_numbers));
tick_locs(tick_locs==0)=1;
tick_locs=date_numbers(tick_locs);
tick_labels=datestr(tick_locs,11);
set(gca,'XLim',[date_numbers(1),date_numbers(end)],...
    'XTick',tick_locs,...
    'XTickLabel',tick_labels)
legend(this.varnames)
if nargout>0
    H=tmp;
end
end
