# TFS-Sprint-Status
[Dashing](http://dashing.io/) widget to display TFS Current Iteration status in a pie chart. Based on [Google Pie Chart](https://gist.github.com/machadolab/b6929c1b913a9f62b12a).
It is currently configured to display `Todo`, `In Progress`, `Removed` and `Done`.

## Dependencies

[httparty](https://github.com/jnunemaker/httparty)

Add it to dashing's gemfile:

  gem 'httparty'

and run `bundle install`.

## Usage

 1. Copy files into you dashboard directory.
 2. Edit `tfs_tasks.yml` to include your specific URLs and credentials.
 3. Use the following snippet in your `dashboard.erb` file.

    ``` HTML
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization","1",{packages:["corechart"]});
    </script>
    <div class="gridster">
      ...
      <li data-row"1" data-col="1" data-sizex="1" data-sizey="3">
        <div data-id="tfs_tasks" data-view="GooglePie"></div>
      </li>
      ...
    </div>
    ```
