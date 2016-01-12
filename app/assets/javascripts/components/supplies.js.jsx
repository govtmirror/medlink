this.Supplies = React.createClass({
    getInitialState: function() {
        return { supplies: this.props.supplies }
    },
    newRecord: function(supply) {
        var s = this.state.supplies.slice()
        s.push(supply)
        this.setState({supplies: s})
    },
    toggleUrl: function(supply) { return "/supplies/" + supply.id + "/toggle_orderable" },

    render: function() {
        return (
            <table className="table table-striped table-linked table-condensed">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Short Code</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    {this.state.supplies.map((supply) => {
                         return (<Supply key={supply.id} supply={supply} toggleUrl={this.toggleUrl(supply)}/>)
                    })}
                    <SupplyForm newRecord={this.newRecord}/>
                </tbody>
            </table>
        )
    }
})