#include "filter.h"

Filter::Filter()
{
    current_progress_ = -1;
}

Filter::~Filter()
{
    graph_ = NULL;
    input_image_ = NULL;
    noise_image_ = NULL;
    filtered_image_ = NULL;
    current_progress_ = -1;
}

void Filter::PrintProgress(int current, int total)
{
    double progress = (current * 100/ total);
    if(progress != current_progress_){
        std::cout << progress << "% " << current << "\r" << std::flush;
    }
    current_progress_ = progress;
}
